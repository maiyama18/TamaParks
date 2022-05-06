import DetailScreen
import Resources
import UICore
import UIKit

public final class ParkListViewController: UIViewController {
    private let viewModel: ParkListViewModel

    private var eventSubscription: Task<Void, Never>?
    private var visitedParkCountSubscription: Task<Void, Never>?

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
        eventSubscription?.cancel()
        visitedParkCountSubscription?.cancel()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        subscribe()
        hostSwiftUIView(ParkListScreen(viewModel: viewModel))
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

    private func subscribe() {
        eventSubscription = Task { [weak self, events = viewModel.events] in
            for await event in events.values {
                switch event {
                case let .showParkDetail(park):
                    guard let self = self else { return }
                    self.showParkDetail(from: self, park: park)
                }
            }
        }

        visitedParkCountSubscription = Task { [weak self, viewModel] in
            for await visitedParkCount in viewModel.$visitedParkCount.values {
                self?.navigationItem.title = L10n.ParkList.title(visitedParkCount)
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
