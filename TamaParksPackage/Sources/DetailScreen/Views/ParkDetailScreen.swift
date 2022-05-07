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

                        if !viewModel.park.photos.isEmpty {
                            Button(action: {}) {
                                Text(L10n.ParkDetail.Photo.edit)
                                    .font(.callout)
                            }
                        }
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.park.photos, id: \.objectID) { photo in
                                Image(uiImage: photo.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 72, height: 72)
                            }

                            Rectangle()
                                .fill(.thickMaterial)
                                .frame(width: 72, height: 72)
                                .overlay(Image(systemName: "camera").font(.system(size: 28)))
                                .onTapGesture {
                                    viewModel.onCameraButtonTapped()
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
