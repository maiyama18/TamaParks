import SwiftUI
import UICore

struct ParkMarker: View {
    let name: String
    let rating: Int
    let metaDataVisible: Bool
    let visited: Bool

    let spacing: CGFloat = 4
    let nameFontSize: CGFloat = 14
    let circleSize: CGFloat = 28
    let triangleHeight: CGFloat = 4

    var color: Color {
        visited ? .green : .gray
    }

    var body: some View {
        ZStack(alignment: .top) {
            Balloon()
                .fill(color.opacity(0.8))
                .frame(width: circleSize, height: circleSize + triangleHeight)
                .overlay(
                    Group {
                        if metaDataVisible {
                            Text(name)
                                .font(.system(size: nameFontSize).bold())
                                .foregroundColor(color)
                                .fixedSize(horizontal: true, vertical: false)
                                .overlay(
                                    Group {
                                        if visited {
                                            RatingStarsView(rating: rating, onRatingTapped: nil, starSize: 12)
                                                .offset(x: 0, y: -(nameFontSize + spacing))
                                        }
                                    }
                                )
                                .offset(x: 0, y: -((circleSize + nameFontSize) * 0.5 + spacing))
                                .transition(.opacity.animation(.easeInOut))
                        }
                    }
                )

            Image(systemName: "leaf.fill")
                .font(.system(size: 12))
                .foregroundColor(.white)
                .frame(width: circleSize, height: circleSize)
        }
        .offset(x: 0, y: -(circleSize + triangleHeight) / 2)
    }
}

struct Balloon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let radius = rect.size.width / 2

        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.minY + radius), radius: radius,
            startAngle: .degrees(70), endAngle: .degrees(110), clockwise: true
        )
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))

        return path
    }
}
