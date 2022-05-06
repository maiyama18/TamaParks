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

        Task { [weak self, parkRepository] in
            for await parks in parkRepository.publisher().values {
                self?.parks = parks
            }
        }
    }

    func onParkTapped(_ park: Park) {
        eventSubject.send(.showParkDetail(park: park))
    }

    func onQueryChanged(_ query: String) {
        parkRepository.changeSearchQuery(query)
    }
}
