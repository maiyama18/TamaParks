import UICore
import UIKit

public final class ParkMapViewController: UIViewController {
    private let viewModel: ParkMapViewModel

    @MainActor
    public init() {
        viewModel = .init()

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        hostSwiftUIView(ParkMapScreen(viewModel: viewModel))
    }
}
