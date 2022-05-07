import SwiftUI

public struct ImageViewerScreen: View {
    private let image: UIImage
    private let onCloseButtonTapped: () -> Void

    init(image: UIImage, onCloseButtonTapped: @escaping () -> Void) {
        self.image = image
        self.onCloseButtonTapped = onCloseButtonTapped
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            ImageView(image: image)

            Button(action: onCloseButtonTapped) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                    .padding(12)
            }
            .offset(x: -12, y: 12)
        }
        .background(Color.black)
    }
}
