import Combine
import Foundation
import Persistence
import Repositories

@MainActor
final class ParkListViewModel: ObservableObject {
    enum Event {
        case showParkDetail(park: Park)
    }

    @Published var parks: [Park] = []

    var events: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    private let eventSubject: PassthroughSubject<Event, Never> = .init()

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

    func onParkTapped(_ park: Park) {
        eventSubject.send(.showParkDetail(park: park))
    }

    func onQueryChanged(_ query: String) {
        parkRepository.changeSearchQuery(query)
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
