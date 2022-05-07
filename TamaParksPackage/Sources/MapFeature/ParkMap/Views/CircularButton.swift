import SwiftUI

struct CircularButton: View {
    var iconSystemName: String
    var onTapped: () -> Void

    var body: some View {
        Button(action: { onTapped() }) {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 64, height: 64)
                .overlay(
                    Image(systemName: iconSystemName)
                        .font(.system(size: 28).bold())
                )
        }
    }
}
