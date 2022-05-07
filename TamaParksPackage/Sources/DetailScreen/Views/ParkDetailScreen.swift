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
                            Button(action: {
                                withAnimation {
                                    viewModel.isEditingPhotos.toggle()
                                }
                            }) {
                                Text(
                                    viewModel.isEditingPhotos
                                        ? L10n.ParkDetail.Photo.complete
                                        : L10n.ParkDetail.Photo.edit
                                )
                                .font(.callout)
                            }
                        }
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.park.photos, id: \.objectID) { photo in
                                ZStack {
                                    Image(uiImage: photo.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 72, height: 72)
                                        .cornerRadius(12)
                                        .onTapGesture {
                                            viewModel.onPhotoTapped(photo)
                                        }

                                    if viewModel.isEditingPhotos {
                                        Circle()
                                            .fill(.red)
                                            .frame(width: 24, height: 24)
                                            .overlay(
                                                Image(systemName: "minus")
                                                    .font(.callout)
                                                    .foregroundColor(.white)
                                                    .fixedSize()
                                            )
                                            .padding()
                                            .onTapGesture {
                                                viewModel.onDeletePhotoButtonTapped(photo)
                                            }
                                    }
                                }
                            }

                            Rectangle()
                                .fill(.thickMaterial)
                                .frame(width: 72, height: 72)
                                .cornerRadius(12)
                                .overlay(Image(systemName: "plus").font(.system(size: 28)))
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
