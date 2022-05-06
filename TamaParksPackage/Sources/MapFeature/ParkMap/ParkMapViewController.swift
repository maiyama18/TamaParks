import DetailScreen
import Resources
import UICore
import UIKit

public final class ParkMapViewController: UIViewController {
    private let viewModel: ParkMapViewModel

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
        hostSwiftUIView(ParkMapScreen(viewModel: viewModel))
        viewModel.onViewLoaded()
    }

    private func subscribeEvents() {
        subscription = Task { [weak self, events = viewModel.events] in
            for await event in events.values {
                guard let self = self else { return }
                switch event {
                case let .showParkDetail(park):
                    self.showParkDetail(from: self, park: park)
                case .locationPermissionDenied:
                    Dialogs.showErrorMessage(from: self, message: L10n.Alert.LocationPermissionDenied.message)
                }
            }
        }
    }
}

extension ParkMapViewController: ParkDetailRouting {}
