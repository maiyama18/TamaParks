import Combine
import Foundation
import Persistence
import Repositories

@MainActor
final class ParkListViewModel: ObservableObject {
    enum Event {
        case showUnVisitConfirmation(park: Park)
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
        if park.visited {
            eventSubject.send(.showUnVisitConfirmation(park: park))
        } else {
            park.visitedAt = Date()
            do {
                try parkRepository.save()
            } catch {
                print(error)
            }
        }
    }

    func onParkUnVisitConfirmed(_ park: Park) {
        park.visitedAt = nil
        park.rating = 0
        do {
            try parkRepository.save()
        } catch {
            print(error)
        }
    }

    func onParkRated(_ park: Park, rating: Int) {
        park.rating = Int16(rating)
        do {
            try parkRepository.save()
        } catch {
            print(error)
        }
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
