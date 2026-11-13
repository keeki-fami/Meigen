import SwiftUI
import WidgetKit

struct MeigenWidgetView: View {
    let entry: QuoteEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        Group {
            if let quote = entry.quote {
                widgetContent(quote)
                    .widgetURL(URL(string: "meigen://quote/\(quote.id.uuidString)"))
            } else {
                Text("アプリで名言を追加してください")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [.indigo.opacity(0.85), .black],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
    }

    @ViewBuilder
    private func widgetContent(_ quote: WidgetQuote) -> some View {
        switch family {
        case .accessoryInline:
            Text(quote.text)
        case .accessoryCircular:
            Image(systemName: "quote.opening")
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 4) {
                Text(quote.text).font(.headline).lineLimit(2)
                if let author = quote.author {
                    Text(author).font(.caption2)
                }
            }
        default:
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "quote.opening").font(.title2)
                Text(quote.text)
                    .font(.system(.headline, design: .serif))
                    .lineLimit(family == .systemSmall ? 4 : 5)
                Spacer(minLength: 0)
                if let author = quote.author {
                    Text("— \(author)").font(.caption).lineLimit(1)
                }
            }
            .foregroundStyle(.white)
            .padding()
        }
    }
}
