import SwiftUI

struct ParkMapScreen: View {
    var body: some View {
        TamaMapView()
            .ignoresSafeArea(.container, edges: .top)
    }
}
