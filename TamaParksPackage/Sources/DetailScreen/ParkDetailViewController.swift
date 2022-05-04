import UIKit

public final class ParkDetailViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()

        setupTitle()
    }

    private func setupTitle() {
        title = "詳細"
        view.backgroundColor = .white
    }
}
