import Combine
import MapKit
import Persistence
import Repositories

private let tamaLocation = CLLocationCoordinate2D(
    latitude: 35.6371,
    longitude: 139.4465
)

@MainActor
final class ParkMapViewModel: ObservableObject {
    enum Event {
        case showParkDetail(park: Park)
    }

    @Published var region: MKCoordinateRegion = .init(
        center: tamaLocation,
        span: .init(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    @Published var parks: [Park] = []

    var parkMetaDataVisible: Bool {
        region.span.longitudeDelta < 0.015
    }

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
}
