import Combine
import CoreData
import Entities
import Persistence
import SwiftUtils
import UIKit

@MainActor
public protocol ParkRepositoryProtocol {
    func parksPublisher() -> AnyPublisher<[Park], Never>
    func visitedParkCountPublisher() -> AnyPublisher<Int, Never>

    func rate(_ park: Park, rating: Int) throws
    func visit(_ park: Park) throws
    func unVisit(_ park: Park) throws
    func addPhoto(_ park: Park, image: UIImage) throws
    func deletePhoto(_ photo: ParkPhoto) throws
    func changeSearchQuery(_ query: String)
    func changeFilter(_ filter: ParkFilter)
    func changeSortOrder(_ sortOrder: ParkSortOrder)
}

public final class ParkRepository: NSObject, ParkRepositoryProtocol {
    private let persistentProvider = PersistentProvider.shared
    private let fetchedResultsController: NSFetchedResultsController<ParkVisiting>

    private var cancellables: [AnyCancellable] = []

    private let filteredParkDatasSubject: CurrentValueSubject<[ParkData], Never> = .init(allParkDatas)
    private let querySubject: CurrentValueSubject<String, Never> = .init("")
    private let filterSubject: CurrentValueSubject<ParkFilter, Never> = .init(.all)
    private let sortOrderSubject: CurrentValueSubject<ParkSortOrder, Never> = .init(.aiueo)
    private let visitingsSubject: CurrentValueSubject<[ParkVisiting], Never> = .init([])
    private let parksSubject: CurrentValueSubject<[Park], Never> = .init([])

    private var viewContext: NSManagedObjectContext {
        persistentProvider.persistentContainer.viewContext
    }

    override public init() {
        let request: NSFetchRequest<ParkVisiting> = ParkVisiting.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ParkVisiting.visitedAt, ascending: true),
        ]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: persistentProvider.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()

        filteredParkDatasSubject
            .combineLatest(visitingsSubject, filterSubject, sortOrderSubject)
            .sink { [weak self] parkDatas, visitings, parkFilter, sortOrder in
                guard let self = self else { return }
                let parkIDToVisitings: [Int: ParkVisiting] = visitings.reduce(into: [:]) { dict, visiting in dict[Int(visiting.parkID)] = visiting }
                let parks = parkDatas.map { parkData in
                    Park(data: parkData, visiting: parkIDToVisitings[parkData.id])
                }
                self.parksSubject.send(
                    parks
                        .filter(parkFilter.predicate)
                        .sorted(by: sortOrder.predicate)
                )
            }
            .store(in: &cancellables)

        querySubject
            .sink { [weak self] query in
                guard let self = self else { return }
                self.filteredParkDatasSubject.send(
                    query.isEmpty
                        ? allParkDatas
                        : allParkDatas.filter { $0.kana.contains(query) || $0.name.contains(query) }
                )
            }
            .store(in: &cancellables)

        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            guard let visitings = fetchedResultsController.fetchedObjects else { return }
            visitingsSubject.send(visitings)
        } catch {
            print(error)
        }
    }

    public func parksPublisher() -> AnyPublisher<[Park], Never> {
        parksSubject.eraseToAnyPublisher()
    }

    public func visitedParkCountPublisher() -> AnyPublisher<Int, Never> {
        visitingsSubject
            .map(\.count)
            .eraseToAnyPublisher()
    }

    public func rate(_ park: Park, rating: Int) throws {
        guard let visiting = park.visiting else {
            throw RepositoryError.invalidState
        }

        visiting.rating = Int16(rating)
        try save()
    }

    public func visit(_ park: Park) throws {
        guard park.visiting == nil else {
            throw RepositoryError.invalidState
        }

        let visiting = ParkVisiting.from(parkID: Int16(park.data.id), rating: 1, visitedAt: Date(), context: viewContext)
        try save()
        park.visiting = visiting
    }

    public func unVisit(_ park: Park) throws {
        guard let visiting = park.visiting else {
            throw RepositoryError.invalidState
        }

        viewContext.delete(visiting)
        try save()
        park.visiting = nil
    }

    public func addPhoto(_ park: Park, image: UIImage) throws {
        guard let visiting = park.visiting else {
            throw RepositoryError.invalidState
        }

        let _ = ParkPhoto.from(image: image, takenAt: Date(), visiting: visiting, context: viewContext)
        try save()
    }

    public func deletePhoto(_ photo: ParkPhoto) throws {
        viewContext.delete(photo)
        try save()
    }

    public func changeSearchQuery(_ query: String) {
        querySubject.send(query)
    }

    public func changeFilter(_ filter: ParkFilter) {
        filterSubject.send(filter)
    }

    public func changeSortOrder(_ sortOrder: ParkSortOrder) {
        sortOrderSubject.send(sortOrder)
    }

    private func save() throws {
        do {
            try viewContext.save()
        } catch {
            print(error)
            viewContext.rollback()
            throw RepositoryError.saveFailed
        }
    }
}

extension ParkRepository: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let visitings = controller.fetchedObjects as? [ParkVisiting] else { return }
        visitingsSubject.send(visitings)
    }
}
