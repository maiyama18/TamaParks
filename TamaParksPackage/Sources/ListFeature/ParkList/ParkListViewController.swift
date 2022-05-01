import UICore
import UIKit

public final class ParkListViewController: UIViewController {
    private let viewModel: ParkListViewModel = .init()

    override public func viewDidLoad() {
        super.viewDidLoad()

        viewModel.onViewLoaded()
        hostSwiftUIView(ParkListScreen(viewModel: viewModel))
    }
}
