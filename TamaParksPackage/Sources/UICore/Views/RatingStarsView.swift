import SwiftUI

public struct RatingStarsView: View {
    private let rating: Int
    private let onRatingTapped: (Int) -> Void

    public init(rating: Int, onRatingTapped: @escaping (Int) -> Void) {
        self.rating = rating
        self.onRatingTapped = onRatingTapped
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(1 ... 5, id: \.self) { i in
                Image(systemName: "star")
                    .font(.system(size: 18))
                    .symbolVariant(rating >= i ? .fill : .none)
                    .foregroundColor(.green)
                    .onTapGesture {
                        onRatingTapped(i)
                    }
            }
        }
    }
}

struct RatingStarsView_Previews: PreviewProvider {
    static var previews: some View {
        RatingStarsView(rating: 3, onRatingTapped: { _ in })
    }
}
