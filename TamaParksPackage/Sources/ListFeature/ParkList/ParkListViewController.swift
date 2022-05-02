import Resources
import UICore
import UIKit

public final class ParkListViewController: UIViewController {
    private let viewModel: ParkListViewModel = .init()
    private var subscription: Task<Void, Never>?

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
                    let alertController = UIAlertController(title: nil, message: L10n.Alert.UnVisit.message(park.name), preferredStyle: .alert)
                    alertController.addAction(.init(title: "削除", style: .destructive, handler: { [weak self] _ in self?.viewModel.onParkUnVisitConfirmed(park) }))
                    alertController.addAction(.init(title: "キャンセル", style: .cancel))
                    present(alertController, animated: true)
                }
            }
        }
    }
}
