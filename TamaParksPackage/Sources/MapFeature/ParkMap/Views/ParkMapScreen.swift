import MapKit
import Persistence
import SwiftUI

struct ParkMapScreen: View {
    @ObservedObject var viewModel: ParkMapViewModel

    var body: some View {
        Map(
            coordinateRegion: $viewModel.region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: .none,
            annotationItems: viewModel.parks,
            annotationContent: { park in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(
                        latitude: park.latitude,
                        longitude: park.longitude
                    )
                ) {
                    ParkMarker(
                        name: park.name,
                        rating: Int(park.rating),
                        metaDataVisible: viewModel.parkMetaDataVisible,
                        visited: park.visited
                    )
                }
            }
        )
        .ignoresSafeArea(.container, edges: .top)
    }
}
