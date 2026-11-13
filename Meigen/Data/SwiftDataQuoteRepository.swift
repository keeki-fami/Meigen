import Foundation
import SwiftData

@MainActor
final class SwiftDataQuoteRepository: QuoteRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() throws -> [Quote] {
        let descriptor = FetchDescriptor<QuoteRecord>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try context.fetch(descriptor).map { $0.asDomain() }
    }

    func save(_ quote: Quote) throws {
        let id = quote.id
        var descriptor = FetchDescriptor<QuoteRecord>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        if let existing = try context.fetch(descriptor).first {
            existing.update(from: quote)
        } else {
            context.insert(QuoteRecord(quote: quote))
        }
        try context.save()
    }

    func delete(id: UUID) throws {
        let targetID = id
        var descriptor = FetchDescriptor<QuoteRecord>(
            predicate: #Predicate { $0.id == targetID }
        )
        descriptor.fetchLimit = 1
        if let record = try context.fetch(descriptor).first {
            context.delete(record)
            try context.save()
        }
    }
}
