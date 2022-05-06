import CoreData
import UIKit

@objc(ParkPhoto)
public class ParkPhoto: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ParkPhoto> {
        NSFetchRequest<ParkPhoto>(entityName: "ParkPhoto")
    }

    @NSManaged public var image: UIImage
    @NSManaged public var takenAt: Date
    @NSManaged public var visiting: ParkVisiting

    public static func from(image: UIImage, takenAt: Date, visiting: ParkVisiting, context: NSManagedObjectContext) -> ParkPhoto {
        let photo = ParkPhoto(context: context)
        photo.image = image
        photo.takenAt = takenAt
        photo.visiting = visiting
        return photo
    }
}
