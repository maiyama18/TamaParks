import Combine
import CoreData
import Persistence

@MainActor
public protocol ParkRepositoryProtocol {
    func insertInitialDataIfNeeded(_ properties: [[String: Any]]) async throws
    func publisher() -> AnyPublisher<[Park], Never>
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
        print("request \(request)")
        print("context \(persistentProvider.persistentContainer.viewContext)")
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
            let parksCount = try context.count(for: fetchRequest)
            print("parksCount \(parksCount)")
            guard parksCount == 0 else { return }

            let insertRequest = NSBatchInsertRequest(entity: Park.entity(), objects: properties)
            try context.execute(insertRequest)
        }
    }

    public func publisher() -> AnyPublisher<[Park], Never> {
        parksSubject.eraseToAnyPublisher()
    }
}

extension ParkRepository: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let visitings = controller.fetchedObjects as? [Park] else { return }
        parksSubject.send(visitings)
    }
}
