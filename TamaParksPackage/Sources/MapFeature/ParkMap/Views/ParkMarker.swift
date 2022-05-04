import Resources
import SwiftUI
import UICore

struct ParkMarker: View {
    let name: String
    let rating: Int
    let metaDataVisible: Bool
    let visited: Bool

    let spacing: CGFloat = 4
    let nameFontSize: CGFloat = 14
    let lineWidth: CGFloat = 1.5
    let circleSize: CGFloat = 32
    let triangleHeight: CGFloat = 4

    var body: some View {
        ZStack(alignment: .top) {
            Balloon()
                .fill(Color.parkGreen)
                .frame(width: circleSize, height: circleSize + triangleHeight)
                .overlay(
                    Group {
                        if metaDataVisible {
                            Text(name)
                                .font(.system(size: nameFontSize).bold())
                                .foregroundColor(.parkGreen)
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

            Circle()
                .fill(visited ? Color.parkGreen : .white)
                .frame(width: circleSize - lineWidth * 2, height: circleSize - lineWidth * 2)
                .padding(.top, lineWidth)
                .overlay(
                    Image(systemName: visited ? "leaf.fill" : "leaf")
                        .foregroundColor(visited ? .white : .parkGreen)
                        .font(.system(size: 14))
                        .offset(x: 0, y: 1)
                )
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
