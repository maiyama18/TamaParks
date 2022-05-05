import SwiftUI

struct ParkStampView: View {
    var parkName: String
    var visitedAt: Date?

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
                            inkView(visitedAt: visitedAt)
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
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .overlay(
                        Group {
                            if visitedAt == nil {
                                Text("訪れた証にタップしてスタンプを押しましょう")
                                    .font(.caption)
                                    .lineLimit(2)
                                    .fixedSize()
                                    .offset(x: 0, y: 32)
                            }
                        }
                    )
            )
            .foregroundColor(.gray)
    }

    private func inkView(visitedAt: Date) -> some View {
        VStack {
            Image(systemName: "leaf")
                .font(.system(size: 180).bold())

            Text(dateFormatter.string(from: visitedAt))
                .font(.system(size: 24, weight: .black).monospaced())
                .fixedSize()
        }
        .foregroundColor(.parkGreen.opacity(0.75))
        .rotationEffect(.degrees(-10))
    }
}
