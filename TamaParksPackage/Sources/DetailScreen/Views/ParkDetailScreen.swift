import Resources
import SwiftUI
import UICore

struct ParkDetailScreen: View {
    @ObservedObject var viewModel: ParkDetailViewModel

    var body: some View {
        VStack {
            ParkStampView(parkName: viewModel.park.name, visitedAt: viewModel.park.visitedAt)
                .padding(.horizontal, 44)
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

                VStack(spacing: 4) {
                    HStack(alignment: .bottom) {
                        Text(L10n.ParkDetail.Photo.title)
                            .font(.body.bold())

                        Spacer()

                        // TODO: 写真が１枚以上あるときのみ表示する
                        Button(action: {}) {
                            Text(L10n.ParkDetail.Photo.edit)
                                .font(.callout)
                        }
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(1 ... 8, id: \.self) { _ in
                                Rectangle()
                                    .fill(.thickMaterial)
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(width: 72, height: 72)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }
}
