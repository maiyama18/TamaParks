import UIKit

public protocol ParkDetailRouting {
    func showParkDetail(from originVC: UIViewController)
}

public extension ParkDetailRouting {
    func showParkDetail(from originVC: UIViewController) {
        let detailVC = ParkDetailViewController()
        let navigationVC = UINavigationController(rootViewController: detailVC)
        navigationVC.modalPresentationStyle = .pageSheet

        if let sheet = navigationVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 24
        }

        originVC.present(navigationVC, animated: true)
    }
}
