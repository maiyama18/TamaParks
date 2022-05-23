import Entities
import MapKit
import Persistence
import SwiftUI
import UICore


struct ParkMapScreen: View {
    final class MapDelegate: NSObject, MKMapViewDelegate {
        public func mapView(_ mapView: MKMapView, didAdd _: [MKAnnotationView]) {
            let userView = mapView.view(for: mapView.userLocation)
            userView?.isUserInteractionEnabled = false
            userView?.isEnabled = false
            userView?.canShowCallout = false
        }
    }
    
    @ObservedObject var viewModel: ParkMapViewModel
    private let mapDelegate: MapDelegate = .init()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
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
                mapView.delegate = mapDelegate
            }
            .zStack(alignment: .bottomTrailing) {
                CircularButton(
                    iconSystemName: "location.fill",
                    onTapped: { viewModel.onCurrentLocationButtonTapped() }
                )
                .padding(24)
            }
            .zStack(alignment: .topTrailing) {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.callout.bold())
                        .foregroundColor(.accentColor)

                    Picker("", selection: $viewModel.parkFilter) {
                        ForEach(ParkFilter.allCases, id: \.self) {
                            Text($0.description)
                                .font(.callout.bold())
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .padding(.top, 48)
                .padding(.trailing, 24)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}
