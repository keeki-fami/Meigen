import Foundation
import WidgetKit

enum AppGroupID {
    // Replace with the App Group enabled for BOTH app and widget targets.
//    static let suiteName = "group.jp.example.Meigen"
    static let suiteName = "group.com.TowaSakurada.MeigenApp"
}

struct WidgetQuote: Codable, Identifiable {
    let id: UUID
    let text: String
    let author: String?
    let source: String?
}

enum QuoteWidgetStore {
    private static let filename = "widget-quotes.json"

    // App target calls this after local data changes.
    static func write(_ quotes: [Quote]) {
        writeSnapshot(quotes.map {
            WidgetQuote(id: $0.id, text: $0.text, author: $0.author, source: $0.source)
        })
    }

    // Shared by app and widget targets; deliberately has no dependency on the domain model.
    static func writeSnapshot(_ snapshot: [WidgetQuote]) {
        guard let data = try? JSONEncoder().encode(snapshot),
              let container = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: AppGroupID.suiteName
              ) else { return }
        let url = container.appendingPathComponent(filename)
        try? data.write(to: url, options: .atomic)
        WidgetCenter.shared.reloadAllTimelines()
    }

    static func read() -> [WidgetQuote] {
        guard let container = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: AppGroupID.suiteName
        ) else { return [] }
        let url = container.appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: url),
              let quotes = try? JSONDecoder().decode([WidgetQuote].self, from: data)
        else { return [] }
        return quotes
    }
}
