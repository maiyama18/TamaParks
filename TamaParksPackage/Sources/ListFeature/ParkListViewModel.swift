import Combine
import Persistence
import Repositories

@MainActor
final class ParkListViewModel: ObservableObject {
    @Published var parks: [Park] = [] {
        didSet {
            print("[DEBUG] \(parks.count) parks")
        }
    }

    private let parkRepository: ParkRepositoryProtocol

    init(parkRepository: ParkRepositoryProtocol = ParkRepository()) {
        self.parkRepository = parkRepository

        Task {
            for await parks in parkRepository.publisher().values {
                self.parks = parks
            }
        }
    }

    func onViewLoaded() {
        insertInitialDataIfNeeded()
    }

    private func insertInitialDataIfNeeded() {
        Task {
            do {
                try await parkRepository.insertInitialDataIfNeeded(initialParkDataProperties)
            } catch {
                print(error)
            }
        }
    }
}
