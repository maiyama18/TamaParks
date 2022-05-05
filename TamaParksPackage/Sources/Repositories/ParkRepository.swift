import Combine
import CoreData
import Persistence

@MainActor
public protocol ParkRepositoryProtocol {
    func insertInitialDataIfNeeded(_ properties: [[String: Any]]) async throws
    func publisher() -> AnyPublisher<[Park], Never>
    func save() throws
    func changeSearchQuery(_ query: String)
}

public final class ParkRepository: NSObject, ParkRepositoryProtocol {
    private let persistentProvider = PersistentProvider.shared
    private let fetchedResultsController: NSFetchedResultsController<Park>

    private let parksSubject: CurrentValueSubject<[Park], Never> = .init([])

    private var viewContext: NSManagedObjectContext {
        persistentProvider.persistentContainer.viewContext
    }

    override public init() {
        let request: NSFetchRequest<Park> = Park.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Park.kana, ascending: true),
        ]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: persistentProvider.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()

        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            guard let parks = fetchedResultsController.fetchedObjects else { return }
            parksSubject.send(parks)
        } catch {
            print(error)
        }
    }

    public func insertInitialDataIfNeeded(_ properties: [[String: Any]]) async throws {
        try await persistentProvider.persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<Park> = Park.fetchRequest()
            fetchRequest.resultType = .countResultType
            guard try context.count(for: fetchRequest) == 0 else { return }

            let insertRequest = NSBatchInsertRequest(entity: Park.entity(), objects: properties)
            try context.execute(insertRequest)
        }

        // FetchedResultController への通知のために無意味な変更を実行する
        try fetchedResultsController.performFetch()
        guard let parks = fetchedResultsController.fetchedObjects, parks.count > 0 else { throw RepositoryError.initializationFailed }
        for park in parks {
            park.rating = 0
        }
        try save()
    }

    public func publisher() -> AnyPublisher<[Park], Never> {
        parksSubject.eraseToAnyPublisher()
    }

    public func save() throws {
        do {
            try viewContext.save()
        } catch {
            print(error)
            viewContext.rollback()
            throw RepositoryError.saveFailed
        }
    }

    public func changeSearchQuery(_ query: String) {
        NSFetchedResultsController<Park>.deleteCache(withName: nil)
        fetchedResultsController.fetchRequest.predicate = query.isEmpty
            ? nil
            : NSPredicate(format: "(%K CONTAINS %@) OR (%K CONTAINS %@)", #keyPath(Park.name), query, #keyPath(Park.kana), query)
        do {
            try fetchedResultsController.performFetch()
            guard let parks = fetchedResultsController.fetchedObjects else { return }
            parksSubject.send(parks)
        } catch {
            print(error)
        }
    }
}

extension ParkRepository: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let parks = controller.fetchedObjects as? [Park] else { return }
        parksSubject.send(parks)
    }
}
