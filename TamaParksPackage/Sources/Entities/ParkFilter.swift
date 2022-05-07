import Persistence
import Resources

public enum ParkFilter: CaseIterable {
    case all
    case notVisited
    case above1Star
    case above2Stars
    case above3Stars
    case above4Stars
    case above5Stars

    public var predicate: (Park) -> Bool {
        switch self {
        case .all:
            return { _ in true }
        case .notVisited:
            return { !$0.visited }
        case .above1Star:
            return { $0.rating >= 1 }
        case .above2Stars:
            return { $0.rating >= 2 }
        case .above3Stars:
            return { $0.rating >= 3 }
        case .above4Stars:
            return { $0.rating >= 4 }
        case .above5Stars:
            return { $0.rating >= 5 }
        }
    }
}

extension ParkFilter: CustomStringConvertible {
    public var description: String {
        switch self {
        case .all:
            return L10n.ParkFilter.all
        case .notVisited:
            return L10n.ParkFilter.notVisited
        case .above1Star:
            return L10n.ParkFilter.above1Star
        case .above2Stars:
            return L10n.ParkFilter.above2Stars
        case .above3Stars:
            return L10n.ParkFilter.above3Stars
        case .above4Stars:
            return L10n.ParkFilter.above4Stars
        case .above5Stars:
            return L10n.ParkFilter.above5Stars
        }
    }
}
