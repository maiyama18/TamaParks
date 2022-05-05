import SwiftUI

struct ParkListScreen: View {
    @ObservedObject var viewModel: ParkListViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.parks, id: \.objectID) { park in
                    ParkListItemRow(
                        park: park
                    )
                    .id(park.viewID)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.onParkTapped(park)
                    }
                }
            }
        }
    }
}
