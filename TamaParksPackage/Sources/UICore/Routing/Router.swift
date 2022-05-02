import Resources
import UIKit

public enum Router {
    public static func showParkUnVisitConfirmationDialog(from originVC: UIViewController, parkName: String, onConfirm: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: L10n.Alert.UnVisit.message(parkName), preferredStyle: .alert)
        alertController.addAction(.init(title: L10n.Common.delete, style: .destructive, handler: { _ in onConfirm() }))
        alertController.addAction(.init(title: L10n.Common.cancel, style: .cancel))
        originVC.present(alertController, animated: true)
    }
}
