import SwiftUI

struct QuoteDetailView: View {
    let quote: Quote
    let image: UIImage?
    let onEdit: () -> Void
    let onDelete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    QuoteCardView(quote: quote, image: image)
                    if let detail = quote.detail, !detail.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("この言葉について").font(.headline)
                            Text(detail).foregroundStyle(.secondary)
                        }
                    }
                    ShareLink(item: quote.shareText) {
                        Label("名言を共有する", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .navigationTitle("名言の詳細")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("閉じる") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("編集", systemImage: "pencil", action: onEdit)
                        Button("削除", systemImage: "trash", role: .destructive) {
                            showDeleteConfirmation = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .confirmationDialog("この名言を削除しますか？", isPresented: $showDeleteConfirmation) {
                Button("削除", role: .destructive) {
                    onDelete()
                    dismiss()
                }
            }
        }
    }
}
