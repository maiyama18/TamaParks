import SwiftUI

public struct RatingStarsView: View {
    private let rating: Int
    private let onRatingTapped: ((Int) -> Void)?
    private let starSize: CGFloat

    public init(rating: Int, onRatingTapped: ((Int) -> Void)?, starSize: CGFloat = 18) {
        self.rating = rating
        self.onRatingTapped = onRatingTapped
        self.starSize = starSize
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(1 ... 5, id: \.self) { i in
                Image(systemName: "star")
                    .font(.system(size: starSize))
                    .symbolVariant(rating >= i ? .fill : .none)
                    .foregroundColor(.green)
                    .onTapGesture {
                        onRatingTapped?(i)
                    }
            }
        }
        .disabled(onRatingTapped == nil)
    }
}

struct RatingStarsView_Previews: PreviewProvider {
    static var previews: some View {
        RatingStarsView(rating: 3, onRatingTapped: { _ in })
    }
}
