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

    func zStack<TopContent: View>(alignment: Alignment, @ViewBuilder topContent: @escaping () -> TopContent) -> some View {
        modifier(ZStackModifier(alignment: alignment, topContent: topContent))
    }
}
