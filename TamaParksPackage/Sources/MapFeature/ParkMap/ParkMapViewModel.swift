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
        span: .init(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    @Published var parks: [Park] = []

    var parkMetaDataVisible: Bool {
        region.span.longitudeDelta < 0.015
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
}
