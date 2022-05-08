import Foundation
import SwiftUtils

public extension PersistentProvider {
    static let shared: PersistentProvider = .init(
        modelURL: Bundle.module.url(forResource: "TamaParks", withExtension: "momd")!,
        modelFileName: "TamaParks",
        containerIdentifier: "iCloud.com.muijp.TamaParks",
        transformers: [
            PersistentProvider.Transformer(
                name: "UIImageTransformer",
                valueTransformer: UIImageTransformer()
            ),
        ]
    )
}
