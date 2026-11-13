import Foundation

/// Repository contract: an Android implementation can use Room or SQLDelight.
@MainActor
protocol QuoteRepository: AnyObject {
    func fetchAll() throws -> [Quote]
    func save(_ quote: Quote) throws
    func delete(id: UUID) throws
}

/// Optional remote boundary. Implement with URLSession on iOS and Ktor on Android.
protocol QuoteSharingService: Sendable {
    func publish(_ quote: Quote) async throws
}
