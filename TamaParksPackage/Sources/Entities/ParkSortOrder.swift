import Foundation

public enum ParkSortOrder: CaseIterable {
    case aiueo
    case visitedAt
    case rating

    public var predicate: (Park, Park) -> Bool {
        switch self {
        case .aiueo:
            return { $0.kana < $1.kana }
        case .visitedAt:
            return { ($0.visitedAt ?? Date.distantPast) > ($1.visitedAt ?? Date.distantPast) }
        case .rating:
            return { $0.rating > $1.rating }
        }
    }
}

extension ParkSortOrder: CustomStringConvertible {
    public var description: String {
        switch self {
        case .aiueo:
            return "50音順"
        case .visitedAt:
            return "訪問順"
        case .rating:
            return "★数順"
        }
    }
}
