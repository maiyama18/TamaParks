import Entities
import Persistence
import Resources
import SwiftUI
import UICore

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd HH:mm"
    return formatter
}()

struct ParkListItemRow: View {
    let park: Park

    var body: some View {
        HStack(spacing: 0) {
            Group {
                if let primaryPhoto = park.primaryPhoto {
                    Image(uiImage: primaryPhoto.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Rectangle()
                        .fill(.gray.opacity(0.2))
                }
            }
            .cornerRadius(12)
            .frame(width: 56, height: 56)

            Spacer()
                .frame(width: 12)

            VStack(alignment: .leading, spacing: 2) {
                Text(park.name)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)

                if let visitedAt = park.visitedAt {
                    Text(dateFormatter.string(from: visitedAt))
                        .font(.subheadline.monospaced())
                        .monospacedDigit()
                        .foregroundColor(.parkGreen)
                        .bold()
                } else {
                    Text(L10n.ParkList.unvisited)
                        .font(.subheadline)
                        .foregroundColor(.parkGreen)
                }
            }

            Spacer()

            if park.visited {
                RatingStarsView(
                    rating: Int(park.rating),
                    onRatingTapped: nil
                )
            }
        }
        .padding()
        .background(park.visited ? Color.parkGreen.opacity(0.2) : Color.clear)
    }
}
