import Foundation
import SwiftUI
import UIKit

@MainActor
@Observable
final class QuoteViewModel {
    private let repository: QuoteRepository
    private let imageStorage: ImageStorageService

    private(set) var quotes: [Quote] = []
    var errorMessage: String?

    init(repository: QuoteRepository, imageStorage: ImageStorageService = .init()) {
        self.repository = repository
        self.imageStorage = imageStorage
        reload()
    }

    func reload() {
        do {
            quotes = try repository.fetchAll()
            QuoteWidgetStore.write(quotes)
        } catch {
            errorMessage = "名言を読み込めませんでした：\(error.localizedDescription)"
        }
    }

    func save(
        id: UUID? = nil,
        text: String,
        source: String?,
        author: String?,
        detail: String?,
        imageData: Data?,
        existingImageFilename: String?
    ) {
        guard Quote.validate(text: text) == nil else {
            errorMessage = Quote.validate(text: text)
            return
        }

        do {
            let old = id.flatMap { target in quotes.first(where: { $0.id == target }) }
            let filename: String?
            if let imageData {
                filename = try imageStorage.save(imageData)
                if old?.imageFilename != filename {
                    imageStorage.delete(filename: old?.imageFilename)
                }
            } else {
                filename = existingImageFilename
            }

            let quote = Quote(
                id: id ?? UUID(),
                text: text.trimmingCharacters(in: .whitespacesAndNewlines),
                source: source, author: author, detail: detail,
                imageFilename: filename,
                createdAt: old?.createdAt ?? .now,
                updatedAt: .now
            )
            try repository.save(quote)
            reload()
        } catch {
            errorMessage = "保存できませんでした：\(error.localizedDescription)"
        }
    }

    func delete(_ quote: Quote) {
        do {
            try repository.delete(id: quote.id)
            imageStorage.delete(filename: quote.imageFilename)
            reload()
        } catch {
            errorMessage = "削除できませんでした：\(error.localizedDescription)"
        }
    }

    func image(for quote: Quote) -> UIImage? {
        imageStorage.load(filename: quote.imageFilename)
    }

    func quote(id: UUID) -> Quote? {
        quotes.first(where: { $0.id == id })
    }
}
