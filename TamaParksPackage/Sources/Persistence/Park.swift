import CoreData
import Foundation

@objc(Park)
public final class Park: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Park> {
        return NSFetchRequest<Park>(entityName: "Park")
    }

    @NSManaged public var kana: String
    @NSManaged public var name: String
    @NSManaged public var rating: Int16
    @NSManaged public var visitedAt: Date?

    public convenience init(name: String, kana: String) {
        self.init()

        self.name = name
        self.kana = kana
    }
}

public extension Park {
    var visited: Bool {
        visitedAt != nil
    }

    var viewID: String {
        "\(objectID).\(visitedAt?.description ?? "nil").\(rating)"
    }
}
