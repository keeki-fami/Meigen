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
struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> MeigenEntry {
        MeigenEntry(
            date: Date(),
            text: "Sample",
            fileNamePath: nil
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping @Sendable (MeigenEntry) -> Void) {
        completion(
            MeigenEntry(
                date: Date(),
                text: "Sample",
                fileNamePath: nil
            )
        )
    }
    
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<MeigenEntry>) -> Void) {
        let currentDate = Date()
        let entry = fetchRandomMeigen()
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!

        completion(
            Timeline(
                entries: [entry],
                policy: .after(nextUpdateDate)
            )
        )
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


struct MeigenEntry: TimelineEntry {
    let date: Date // widgetを表示する日付を指定する必要がある。
    let text: String
    let fileNamePath: String?
}

// ウィジェットのデザイン
struct MeigenWidgetEntryView : View {
    var entry: Provider.Entry
    private let imageStorageService = ImageStorageService()

    var body: some View {
        Group {
            if let image = imageStorageService.load(filename: entry.fileNamePath) {
                Image(uiImage: image)
                    .overlay(alignment: .bottomLeading) {
                        Text("\(entry.text)")
                            .font(.system(size: 15, weight: .semibold, design: .serif))
                            .padding()
                    }
            } else {
                LinearGradient(
                    colors: [.indigo.opacity(0.85), .black.opacity(0.92)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                .overlay(alignment: .bottomLeading) {
                    Text("\(entry.text)")
                        .font(.system(size: 15, weight: .semibold, design: .serif))
                        .padding()
                }
            }
        }
        .onAppear() {
            print("\(String(describing: imageStorageService.load(filename: entry.fileNamePath)))")
        }
    }
}

// ウィジェット
struct MeigenWidget: Widget {
    let kind: String = "MeigenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MeigenWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    MeigenWidget()
} timeline: {
    MeigenEntry(date: .now, text: "Sample1", fileNamePath: nil)
    MeigenEntry(date: .now, text: "Sample2", fileNamePath: nil)
}
