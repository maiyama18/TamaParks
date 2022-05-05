import MapKit
import Persistence
import SwiftUI
import UICore

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
                        visited: park.visited,
                        onTapped: { viewModel.onParkTapped(park) }
                    )
                }
            }
        )
        .introspectMapView { mapView in
            mapView.pointOfInterestFilter = .excludingAll
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}
