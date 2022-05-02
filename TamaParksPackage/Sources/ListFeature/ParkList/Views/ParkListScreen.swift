import SwiftUI

struct ParkListScreen: View {
    @ObservedObject var viewModel: ParkListViewModel

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.parks, id: \.id) { park in
                    ParkListItemRow(
                        park: park,
                        onRatingTapped: { _ in }
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
