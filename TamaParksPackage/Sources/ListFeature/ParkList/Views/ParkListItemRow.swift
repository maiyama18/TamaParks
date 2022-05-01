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
    let onRatingTapped: (Int) -> Void

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(.gray.opacity(0.2))
                .cornerRadius(12)
                .frame(width: 56, height: 56)

            Spacer()
                .frame(width: 12)

            VStack(alignment: .leading, spacing: 2) {
                Text(park.name!)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)

                if let visitedAt = park.visitedAt {
                    Text(dateFormatter.string(from: visitedAt))
                        .font(.subheadline.monospaced())
                        .monospacedDigit()
                        .foregroundColor(Color.green)
                        .bold()
                } else {
                    Text(L10n.ParkList.unvisited)
                        .font(.subheadline)
                        .foregroundColor(Color.green)
                }
            }

            Spacer()

            if park.visited {
                RatingStarsView(
                    rating: Int(park.rating),
                    onRatingTapped: { rating in onRatingTapped(rating) }
                )
            }
        }
        .padding()
        .background(park.visited ? Color.green.opacity(0.2) : Color.clear)
    }
}

struct ParkListItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ParkListItemRow(park: Park(name: "多摩中央公園", kana: "たまちゅうおうこうえん"), onRatingTapped: { _ in })
    }
}
