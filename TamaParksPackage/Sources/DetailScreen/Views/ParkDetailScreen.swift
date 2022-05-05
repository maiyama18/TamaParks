import SwiftUI
import UICore

struct ParkDetailScreen: View {
    @ObservedObject var viewModel: ParkDetailViewModel

    var body: some View {
        VStack {
            ParkStampView(parkName: viewModel.park.name, visitedAt: viewModel.park.visitedAt)
                .padding(.horizontal, 24)
                .contentShape(Circle())
                .onTapGesture {
                    viewModel.onStampTapped()
                }

            if viewModel.park.visited {
                RatingStarsView(
                    rating: Int(viewModel.park.rating),
                    onRatingTapped: { rating in viewModel.onParkRated(rating: rating) },
                    starSize: 28
                )
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 36)
    }
}
