import SwiftUI
import PhotosUI

struct QuoteEditorView: View {
    let quote: Quote?
    let onSave: (String, String?, String?, String?, Data?, String?) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var text: String
    @State private var source: String
    @State private var author: String
    @State private var detail: String
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var imagePreview: UIImage?
    @State private var validationError: String?

    init(quote: Quote?, initialImage: UIImage?, onSave: @escaping (String, String?, String?, String?, Data?, String?) -> Void) {
        self.quote = quote
        self.onSave = onSave
        _text = State(initialValue: quote?.text ?? "")
        _source = State(initialValue: quote?.source ?? "")
        _author = State(initialValue: quote?.author ?? "")
        _detail = State(initialValue: quote?.detail ?? "")
        _imagePreview = State(initialValue: initialImage)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("名言") {
                    TextEditor(text: $text)
                        .frame(minHeight: 110)
                    if let validationError {
                        Text(validationError).font(.caption).foregroundStyle(.red)
                    }
                }
                Section("情報（任意）") {
                    TextField("発言者", text: $author)
                    TextField("出典・引用元", text: $source)
                    TextField("詳細・メモ", text: $detail, axis: .vertical)
                        .lineLimit(3...7)
                }
                Section("背景画像") {
                    if let imagePreview {
                        Image(uiImage: imagePreview)
                            .resizable().scaledToFill()
                            .frame(height: 160).frame(maxWidth: .infinity)
                            .clipped().clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Label("写真を選択", systemImage: "photo")
                    }
                    if imagePreview != nil {
                        Button("画像を外す", role: .destructive) {
                            imagePreview = nil
                            imageData = nil
                            selectedPhoto = nil
                        }
                    }
                }
            }
            .navigationTitle(quote == nil ? "名言を追加" : "名言を編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存") {
                        guard Quote.validate(text: text) == nil else {
                            validationError = "名言を入力してください。"
                            return
                        }
                        onSave(text, source, author, detail, imageData, (imagePreview == nil ? nil : quote?.imageFilename))
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onChange(of: selectedPhoto) { _, item in
                Task {
                    guard let data = try? await item?.loadTransferable(type: Data.self),
                          let image = UIImage(data: data) else { return }
                    imageData = data
                    imagePreview = image
                }
            }
        }
    }
}
