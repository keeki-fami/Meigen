import SwiftUI

struct QuoteListView: View {
    @Environment(QuoteViewModel.self) private var model
    @State private var displayMode = 0
    @State private var selectedQuote: Quote?
    @State private var editingQuote: Quote?
    @State private var showingEditor = false
    @State private var deepLinkQuoteID: UUID?

    var body: some View {
        NavigationStack {
            Group {
                if model.quotes.isEmpty {
                    ContentUnavailableView(
                        "名言がまだありません",
                        systemImage: "quote.opening",
                        description: Text("心に留めておきたい言葉を追加してみましょう。")
                    )
                } else if displayMode == 0 {
                    List(model.quotes) { quote in
                        Button {
                            selectedQuote = quote
                        } label: {
                            QuoteCardView(quote: quote, image: model.image(for: quote))
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
                    }
                    .listStyle(.plain)
                } else {
                    QuoteSwipeView(quotes: model.quotes) { quote in
                        selectedQuote = quote
                    }
//                    TabView {
//                        ForEach(model.quotes) { quote in
//                            Button {
//                                selectedQuote = quote
//                            } label: {
//                                QuoteCardView(quote: quote, image: model.image(for: quote))
//                                    .padding(.horizontal, 20)
//                            }
//                            .buttonStyle(.plain)
//                        }
//                    }
//                    .tabViewStyle(.page)
                }
            }
            .navigationTitle("名言")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Picker("表示形式", selection: $displayMode) {
                        Image(systemName: "list.bullet").tag(0)
                        Image(systemName: "rectangle.stack").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 105)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        editingQuote = nil
                        showingEditor = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("名言を追加")
                }
            }
            .sheet(item: $selectedQuote) { quote in
                QuoteDetailView(
                    quote: quote,
                    image: model.image(for: quote),
                    onEdit: {
                        selectedQuote = nil
                        editingQuote = quote
                        showingEditor = true
                    },
                    onDelete: { model.delete(quote) }
                )
            }
            .sheet(isPresented: $showingEditor) {
                QuoteEditorView(
                    quote: editingQuote,
                    initialImage: editingQuote.flatMap { model.image(for: $0) }
                ) { text, source, author, detail, imageData, oldFilename in
                    model.save(
                        id: editingQuote?.id, text: text, source: source,
                        author: author, detail: detail, imageData: imageData,
                        existingImageFilename: oldFilename
                    )
                }
            }
            .onOpenURL { url in
                guard url.scheme == "meigen",
                      url.host == "quote",
                      let idString = url.pathComponents.dropFirst().first,
                      let id = UUID(uuidString: idString) else { return }
                deepLinkQuoteID = id
            }
            .onChange(of: model.quotes) { _, quotes in
                guard let id = deepLinkQuoteID,
                      let match = quotes.first(where: { $0.id == id }) else { return }
                selectedQuote = match
                deepLinkQuoteID = nil
            }
            .alert("エラー", isPresented: Binding(
                get: { model.errorMessage != nil },
                set: { if !$0 { model.errorMessage = nil } }
            )) {
                Button("OK") { model.errorMessage = nil }
            } message: {
                Text(model.errorMessage ?? "")
            }
        }
    }
}
