import SwiftUI

struct ZStackModifier<TopContent: View>: ViewModifier {
    let alignment: Alignment
    @ViewBuilder let topContent: () -> TopContent

    func body(content: Content) -> some View {
        ZStack(alignment: alignment) {
            content
            topContent()
        }
    }
}
