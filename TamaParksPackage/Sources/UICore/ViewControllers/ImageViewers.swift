import UIKit

public enum ImageViewers {
    public static func show(from originVC: UIViewController, image: UIImage) {
        let viewer = ImageViewerViewController(image: image)
        viewer.modalTransitionStyle = .crossDissolve
        viewer.modalPresentationStyle = .fullScreen
        originVC.present(viewer, animated: true)
    }
}
