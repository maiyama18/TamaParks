import Resources
import UIKit

public enum Dialogs {
    public static func showDestructiveActionConfirmation(from originVC: UIViewController, message: String, confirmationText: String, onConfirmed: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: confirmationText, style: .destructive, handler: { _ in onConfirmed() }))
        alertController.addAction(.init(title: L10n.Common.cancel, style: .cancel))
        originVC.present(alertController, animated: true)
    }

    public static func showErrorMessage(from originVC: UIViewController, message: String) {
        let alertController = UIAlertController(title: L10n.Common.error, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: L10n.Common.ok, style: .default))
        originVC.present(alertController, animated: true)
    }
}
