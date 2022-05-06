import Resources
import UIKit

public enum Dialogs {
    public static func showParkUnVisitConfirmation(from originVC: UIViewController, parkName: String, onConfirm: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: L10n.Alert.UnVisit.message(parkName), preferredStyle: .alert)
        alertController.addAction(.init(title: L10n.Common.delete, style: .destructive, handler: { _ in onConfirm() }))
        alertController.addAction(.init(title: L10n.Common.cancel, style: .cancel))
        originVC.present(alertController, animated: true)
    }

    public static func showErrorMessage(from originVC: UIViewController, message: String) {
        let alertController = UIAlertController(title: L10n.Common.error, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: L10n.Common.ok, style: .default))
        originVC.present(alertController, animated: true)
    }
}
