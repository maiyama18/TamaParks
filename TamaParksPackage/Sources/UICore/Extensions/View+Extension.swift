import Introspect
import MapKit
import SwiftUI

public extension View {
    func introspectMapView(customize: @escaping (MKMapView) -> Void) -> some View {
        inject(UIKitIntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: MKMapView.self, from: viewHost)
            },
            customize: customize
        ))
    }
}
