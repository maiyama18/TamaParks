import Combine
import Foundation
import Persistence
import Repositories

@MainActor
class ParkDetailViewModel: ObservableObject {
    enum Event {
        case showUnVisitConfirmation(parkName: String)
    }

    @Published var park: Park

    var events: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    private let eventSubject: PassthroughSubject<Event, Never> = .init()

    private let parkRepository: ParkRepositoryProtocol

    init(park: Park, parkRepository: ParkRepositoryProtocol = ParkRepository()) {
        self.park = park
        self.parkRepository = parkRepository
    }

    func onStampTapped() {
        if park.visited {
            eventSubject.send(.showUnVisitConfirmation(parkName: park.name))
        } else {
            park.visitedAt = Date()
        }

        do {
            try parkRepository.save()
            objectWillChange.send()
        } catch {
            print(error)
        }
    }

    func onParkRated(rating: Int) {
        park.rating = Int16(rating)

        do {
            try parkRepository.save()
            objectWillChange.send()
        } catch {
            print(error)
        }
    }

    func onParkUnVisitConfirmed() {
        park.visitedAt = nil
        park.rating = 0
        do {
            try parkRepository.save()
            objectWillChange.send()
        } catch {
            print(error)
        }
    }
}
