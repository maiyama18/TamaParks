import Combine
import Entities
import MapKit
import Repositories
import SwiftUI
import SwiftUtils

private let tamaLocation = CLLocationCoordinate2D(
    latitude: 35.6371,
    longitude: 139.4465
)

@MainActor
final class ParkMapViewModel: ObservableObject {
    enum Event {
        case showParkDetail(park: Park)
        case locationPermissionDenied
    }

    @Published var region: MKCoordinateRegion = .init(
        center: tamaLocation,
        span: .init(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    @Published var parks: [Park] = []
    @Published var parkFilter: ParkFilter = .all {
        didSet {
            parkRepository.changeFilter(parkFilter)
        }
    }

    var parkMetaDataVisible: Bool {
        region.span.longitudeDelta < 0.015
    }

    var events: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    private let eventSubject: PassthroughSubject<Event, Never> = .init()

    private let parkRepository: ParkRepositoryProtocol
    private let locationService: LocationServiceProtocol

    init(
        parkRepository: ParkRepositoryProtocol = ParkRepository(),
        locationService: LocationServiceProtocol = LocationService.shared
    ) {
        self.parkRepository = parkRepository
        self.locationService = locationService

        Task { [weak self, parkRepository] in
            for await parks in parkRepository.parksPublisher().values {
                self?.parks = parks
            }
        }
    }

    func onViewLoaded() {
        locationService.requestPermission()
    }

    func onParkTapped(_ park: Park) {
        eventSubject.send(.showParkDetail(park: park))
    }

    func onCurrentLocationButtonTapped() {
        switch locationService.checkPermission() {
        case .allowed:
            guard let location = locationService.getLocation() else { return }
            withAnimation {
                region.center = location
            }
        case .denied:
            eventSubject.send(.locationPermissionDenied)
        case .notDetermined:
            locationService.requestPermission()
        }
    }
}
