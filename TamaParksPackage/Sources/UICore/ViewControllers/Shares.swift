import UIKit

public enum Shares {
    public static func show(from originVC: UIViewController, item: Any) {
        let shareVC = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        originVC.present(shareVC, animated: true)
    }
}
