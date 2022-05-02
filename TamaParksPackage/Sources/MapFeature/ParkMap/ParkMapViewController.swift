import UICore
import UIKit

public final class ParkMapViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()

        hostSwiftUIView(ParkMapScreen())
    }
}
