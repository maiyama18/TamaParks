import SwiftUI

struct ParkListScreen: View {
    @ObservedObject var viewModel: ParkListViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.parks) { park in
                    ParkListItemRow(
                        park: park
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.onParkTapped(park)
                    }
                }
            }
        }
    }
}
