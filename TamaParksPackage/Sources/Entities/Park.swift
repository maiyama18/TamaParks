import Foundation
import Persistence

public class Park {
    public let data: ParkData
    public var visiting: ParkVisiting?

    public init(data: ParkData, visiting: ParkVisiting?) {
        self.data = data
        self.visiting = visiting
    }

    public var name: String {
        data.name
    }

    public var rating: Int {
        Int(visiting?.rating ?? 0)
    }

    public var latitude: Double {
        data.latitude
    }

    public var longitude: Double {
        data.longitude
    }

    public var visitedAt: Date? {
        visiting?.visitedAt
    }

    public var visited: Bool {
        visitedAt != nil
    }

    public var photos: [ParkPhoto] {
        visiting?.photos.sorted(by: { $0.takenAt < $1.takenAt }) ?? []
    }

    public var primaryPhoto: ParkPhoto? {
        photos.first
    }
}

extension Park: Identifiable {
    public var id: Int { data.id }
}
