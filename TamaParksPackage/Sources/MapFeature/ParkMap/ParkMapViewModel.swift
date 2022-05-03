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
    @Published var region: MKCoordinateRegion = .init(
        center: tamaLocation,
        latitudinalMeters: 2000,
        longitudinalMeters: 2000
    )

    @Published var parks: [Park] = []

    private let parkRepository: ParkRepositoryProtocol

    init(parkRepository: ParkRepositoryProtocol = ParkRepository()) {
        self.parkRepository = parkRepository

        Task {
            for await parks in parkRepository.publisher().values {
                self.parks = parks
            }
        }
    }
}
