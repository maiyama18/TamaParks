import MapKit
import SwiftUI

private let tamaLocation = CLLocationCoordinate2D(
    latitude: 35.6371,
    longitude: 139.4465
)

final class TamaMapView: UIViewRepresentable {
    final class Coordinator: NSObject, MKMapViewDelegate {}

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.region = MKCoordinateRegion(
            center: tamaLocation,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_: MKMapView, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}
