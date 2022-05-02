import Resources
import UICore
import UIKit

public final class ParkListViewController: UIViewController {
    private let viewModel: ParkListViewModel

    private var subscription: Task<Void, Never>?

    @MainActor
    public init() {
        viewModel = .init()

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        subscription?.cancel()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        subscribeEvents()
        viewModel.onViewLoaded()
        hostSwiftUIView(ParkListScreen(viewModel: viewModel))
    }

    private func subscribeEvents() {
        subscription = Task {
            for await event in viewModel.events.values {
                switch event {
                case let .showUnVisitConfirmation(park):
                    Router.showParkUnVisitConfirmationDialog(
                        from: self,
                        parkName: park.name,
                        onConfirm: { [weak self] in self?.viewModel.onParkUnVisitConfirmed(park) }
                    )
                }
            }
        }
    }
}
