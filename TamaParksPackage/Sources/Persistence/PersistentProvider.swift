import CoreData

public final class PersistentProvider {
    public static let shared: PersistentProvider = .init()

    public let persistentContainer: NSPersistentCloudKitContainer

    private init() {
        ValueTransformer.setValueTransformer(UIImageTransformer(), forName: .init(rawValue: "UIImageTransformer"))

        let modelURL = Bundle.module.url(forResource: "TamaParks", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        persistentContainer = NSPersistentCloudKitContainer(name: "TamaParks", managedObjectModel: model)

        let storeDirectory = NSPersistentCloudKitContainer.defaultDirectoryURL()
        let storeURL = storeDirectory.appendingPathComponent("Synced.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.muijp.TamaParks")
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        persistentContainer.persistentStoreDescriptions = [description]

        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true

        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("failed to load CoreData store: \(error)")
            }
        }
    }
}
