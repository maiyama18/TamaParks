import UICore
import UIKit

public final class ParkDetailViewController: UIViewController {
    private let viewModel: ParkDetailViewModel

    private var subscription: Task<Void, Never>?

    init(viewModel: ParkDetailViewModel) {
        self.viewModel = viewModel

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
        hostSwiftUIView(ParkDetailScreen(viewModel: viewModel))
    }

    private func subscribeEvents() {
        subscription = Task { [weak self, events = viewModel.events] in
            for await event in events.values {
                switch event {
                case let .showUnVisitConfirmation(parkName):
                    guard let self = self else { return }
                    Dialogs.showParkUnVisitConfirmation(
                        from: self,
                        parkName: parkName,
                        onConfirm: { [weak self] in self?.viewModel.onParkUnVisitConfirmed() }
                    )
                }
            }
        }
    }
}