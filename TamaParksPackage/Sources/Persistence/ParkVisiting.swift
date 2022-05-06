import CoreData
import Foundation

@objc(ParkVisiting)
public final class ParkVisiting: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ParkVisiting> {
        NSFetchRequest<ParkVisiting>(entityName: "ParkVisiting")
    }

    @NSManaged public var parkID: Int16
    @NSManaged public var rating: Int16
    @NSManaged public var visitedAt: Date
    @NSManaged public var photos: [ParkPhoto]

    public static func from(parkID: Int16, rating: Int16, visitedAt: Date, context: NSManagedObjectContext) -> ParkVisiting {
        let visiting = ParkVisiting(context: context)

        visiting.parkID = parkID
        visiting.rating = rating
        visiting.visitedAt = visitedAt
        visiting.photos = []

        return visiting
    }
}
