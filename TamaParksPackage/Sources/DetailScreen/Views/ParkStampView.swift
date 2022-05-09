import Resources
import SwiftUI

struct ParkStampView: View {
    var parkName: String
    var visitedAt: Date?

    @State private var hapticScale: CGFloat = 1

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm"
        return formatter
    }()

    var body: some View {
        GeometryReader { proxy in
            baseView(parkName: parkName, size: proxy.size.width)
                .overlay(
                    Group {
                        if let visitedAt = visitedAt {
                            inkView(visitedAt: visitedAt, iconSize: proxy.size.width * 0.7)
                                .scaleEffect(hapticScale)
                        }
                    }
                    .onChange(of: visitedAt) { visitedAt in
                        if visitedAt != nil {
                            withAnimation(.easeInOut(duration: 0.05).delay(0.05)) {
                                hapticScale = 1.15
                            }
                            withAnimation(.easeInOut.delay(0.1)) {
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                                hapticScale = 1
                            }
                        }
                    }
                )
        }
    }

    private func baseView(parkName: String, size: CGFloat) -> some View {
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
            .frame(width: size, height: size)
            .overlay(
                Text(parkName)
                    .font(.title.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .overlay(
                        Group {
                            if visitedAt == nil {
                                Text(L10n.ParkDetail.Stamp.prompt)
                                    .font(.caption)
                                    .lineLimit(1)
                                    .fixedSize()
                                    .offset(x: 0, y: 32)
                            }
                        }
                    )
                    .padding()
            )
            .foregroundColor(.gray)
    }

    private func inkView(visitedAt: Date, iconSize: CGFloat) -> some View {
        VStack {
            Image(systemName: "leaf")
                .font(.system(size: iconSize).bold())

            Text(dateFormatter.string(from: visitedAt))
                .font(.system(size: 24, weight: .black).monospaced())
                .fixedSize()
        }
        .foregroundColor(.parkGreen.opacity(0.75))
        .rotationEffect(.degrees(-10))
    }
}
