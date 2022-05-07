import Combine
import Foundation
import Persistence
import Repositories
import UIKit

@MainActor
class ParkDetailViewModel: ObservableObject {
    enum Event {
        case showUnVisitConfirmation(parkName: String)
        case showCamera
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
            do {
                try parkRepository.visit(park)
                objectWillChange.send()
            } catch {
                print(error)
            }
        }
    }

    func onParkRated(rating: Int) {
        do {
            try parkRepository.rate(park, rating: rating)
            objectWillChange.send()
        } catch {
            print(error)
        }
    }

    func onParkUnVisitConfirmed() {
        do {
            try parkRepository.unVisit(park)
            objectWillChange.send()
        } catch {
            print(error)
        }
    }

    func onCameraButtonTapped() {
        eventSubject.send(.showCamera)
    }

    func onPhotoTaken(image: UIImage) {
        do {
            try parkRepository.addPhoto(park, image: image)
            objectWillChange.send()
        } catch {
            print(error)
        }
    }
}
