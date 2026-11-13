import Foundation

/// Portable domain entity. Keep this type independent of SwiftUI and SwiftData.
struct Quote: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var text: String
    var source: String?
    var author: String?
    var detail: String?
    /// Relative filename in the app's documents/Quotes directory, never an absolute path.
    var imageFilename: String?
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        text: String,
        source: String? = nil,
        author: String? = nil,
        detail: String? = nil,
        imageFilename: String? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.text = text
        self.source = Self.cleaned(source)
        self.author = Self.cleaned(author)
        self.detail = Self.cleaned(detail)
        self.imageFilename = imageFilename
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var shareText: String {
        var lines = ["「\(text)」"]
        if let author { lines.append("— \(author)") }
        if let source { lines.append("出典：\(source)") }
        return lines.joined(separator: "\n")
    }

    static func cleaned(_ value: String?) -> String? {
        guard let value else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    static func validate(text: String) -> String? {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "名言を入力してください。"
            : nil
    }
}
