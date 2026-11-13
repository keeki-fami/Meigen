import WidgetKit
import SwiftUI

struct QuoteEntry: TimelineEntry {
    let date: Date
    let quote: WidgetQuote?
}

struct QuoteProvider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(date: .now, quote: WidgetQuote(
            id: UUID(), text: "心に留めておきたい言葉を、日常の中に。", author: "Meigen", source: nil
        ))
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        completion(QuoteEntry(date: .now, quote: QuoteWidgetStore.read().first))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        let quotes = QuoteWidgetStore.read()
        let entry = QuoteEntry(date: .now, quote: quotes.randomElement())
        completion(Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(60 * 60))))
    }
}

struct MeigenWidget: Widget {
    let kind = "MeigenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuoteProvider()) { entry in
            MeigenWidgetView(entry: entry)
        }
        .configurationDisplayName("今日の名言")
        .description("登録した名言をホーム画面やロック画面に表示します。")
        .supportedFamilies([
            .systemSmall, .systemMedium, .systemLarge,
            .accessoryRectangular, .accessoryInline, .accessoryCircular
        ])
    }
}

@main
struct MeigenWidgetBundle: WidgetBundle {
    var body: some Widget {
        MeigenWidget()
    }
}
