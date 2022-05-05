import Persistence
import UIKit

@MainActor
public protocol ParkDetailRouting {
    func showParkDetail(from originVC: UIViewController, park: Park)
}

public extension ParkDetailRouting {
    func showParkDetail(from originVC: UIViewController, park: Park) {
        let detailVM = ParkDetailViewModel(park: park)
        let detailVC = ParkDetailViewController(viewModel: detailVM)
        detailVC.modalPresentationStyle = .pageSheet

        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 24
            sheet.prefersGrabberVisible = true
        }

        originVC.present(detailVC, animated: true)
    }
}
