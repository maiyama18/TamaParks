import Foundation

enum RepositoryError: Error {
    case saveFailed
    case initializationFailed
    case invalidState
}
