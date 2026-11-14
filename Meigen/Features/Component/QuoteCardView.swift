import SwiftUI

struct QuoteCardView: View {
    let quote: Quote
    let image: UIImage?

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { proxy in
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                } else {
                    LinearGradient(
                        colors: [.indigo.opacity(0.85), .black.opacity(0.92)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                }
            }
            LinearGradient(
                colors: [.clear, .black.opacity(0.78)],
                startPoint: .center, endPoint: .bottom
            )
            VStack(alignment: .leading, spacing: 12) {
                Text("“\(quote.text)”")
                    .font(.system(size: 25, weight: .semibold, design: .serif))
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                if let author = quote.author {
                    Text("— \(author)")
                        .font(.subheadline.weight(.medium))
                }
                if let source = quote.source {
                    Text(source).font(.caption).opacity(0.8)
                }
            }
            .foregroundStyle(.white)
            .padding(22)
        }
        .frame(height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.12), radius: 12, y: 6)
    }
}
