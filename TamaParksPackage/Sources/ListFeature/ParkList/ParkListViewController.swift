import DetailScreen
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

        setupTitle()
        setupSearchController()
        subscribeEvents()
        viewModel.onViewLoaded()
        hostSwiftUIView(ParkListScreen(viewModel: viewModel))
    }

    private func setupTitle() {
        navigationItem.title = L10n.ParkList.title
    }

    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = L10n.ParkList.searchPlaceholder
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func subscribeEvents() {
        subscription = Task {
            for await event in viewModel.events.values {
                switch event {
                case let .showParkDetail(park):
                    showParkDetail(from: self, park: park)
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

extension ParkListViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        viewModel.onQueryChanged(query)
    }
}

extension ParkListViewController: ParkDetailRouting {}
