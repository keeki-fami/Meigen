import Foundation
import SwiftData

@Model
final class QuoteRecord {
    @Attribute(.unique) var id: UUID
    var text: String
    var source: String?
    var author: String?
    var detail: String?
    var imageFilename: String?
    var createdAt: Date
    var updatedAt: Date

    init(quote: Quote) {
        id = quote.id
        text = quote.text
        source = quote.source
        author = quote.author
        detail = quote.detail
        imageFilename = quote.imageFilename
        createdAt = quote.createdAt
        updatedAt = quote.updatedAt
    }

    func asDomain() -> Quote {
        Quote(
            id: id, text: text, source: source, author: author,
            detail: detail, imageFilename: imageFilename,
            createdAt: createdAt, updatedAt: updatedAt
        )
    }

    func update(from quote: Quote) {
        text = quote.text
        source = quote.source
        author = quote.author
        detail = quote.detail
        imageFilename = quote.imageFilename
        updatedAt = .now
    }
}
