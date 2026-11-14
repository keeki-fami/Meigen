//
//  MeigenWidget.swift
//  MeigenWidgetExtension
//  
//  Created by keeki-fami on 2026/11/14
//  
//

import WidgetKit
import SwiftUI
import SwiftData

// 表示するデータの提供
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MeigenEntry {
        MeigenEntry(
            date: Date(),
            text: "Sample",
            fileNamePath: nil
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> MeigenEntry {
        MeigenEntry(
            date: Date(),
            text: "Sample",
            fileNamePath: nil
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<MeigenEntry> {
        let currentDate = Date()
        let entry = fetchRandomMeigen()
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 12, to: currentDate)!

        return Timeline(entries: [entry], policy: .after(nextUpdateDate))
    }
    
    func fetchRandomMeigen() -> MeigenEntry {
        do {
            let container = try SharedModelContainer.create()
            let context = ModelContext(container)
            let descriptor = FetchDescriptor<QuoteRecord>(
                sortBy: [
                    SortDescriptor(\.createdAt, order: .reverse)
                ]
            )
            let models = try context.fetch(descriptor).randomElement()
            if let model = models {
                return MeigenEntry (
                    date: .now,
                    text: model.text,
                    fileNamePath: model.imageFilename
                )
            } else {
                return MeigenEntry(
                    date: .now,
                    text: "Sample",
                    fileNamePath: nil
                )
            }
        } catch {
            print("Widget fetch error: \(error)")

            return MeigenEntry(
                date: .now,
                text: "名言を追加しよう",
                fileNamePath: nil
            )
        }
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

// 表示するデータの内容
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: ConfigurationAppIntent
//}

struct MeigenEntry: TimelineEntry {
    let date: Date // widgetを表示する日付を指定する必要がある。
    let text: String
    let fileNamePath: String?
}

// ウィジェットのデザイン
struct MeigenWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Rectangle()
                .fill(.blue)
                .overlay(alignment: .bottomLeading) {
                    Text("\(entry.text)")
                        .padding()
                }
        }
    }
}

// ウィジェット
struct MeigenWidget: Widget {
    let kind: String = "MeigenWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MeigenWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    MeigenWidget()
} timeline: {
    MeigenEntry(date: .now, text: "Sample1", fileNamePath: nil)
    MeigenEntry(date: .now, text: "Sample2", fileNamePath: nil)
}
