import CoreData

public final class PersistentProvider {
    public static let shared: PersistentProvider = .init()

    public let persistentContainer: NSPersistentCloudKitContainer

    private init() {
        persistentContainer = NSPersistentCloudKitContainer(name: "TamaParks")

        let description = NSPersistentStoreDescription()
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
