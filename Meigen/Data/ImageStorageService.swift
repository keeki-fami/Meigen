import Foundation
import UIKit

struct ImageStorageService {
    private let folderName = "Quotes"

    private var folderURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent(folderName, isDirectory: true)
    }

    func save(_ data: Data) throws -> String {
        try FileManager.default.createDirectory(
            at: folderURL, withIntermediateDirectories: true
        )
        let filename = "\(UUID().uuidString).jpg"
        let destination = folderURL.appendingPathComponent(filename)
        if let image = UIImage(data: data),
           let jpeg = image.jpegData(compressionQuality: 0.86) {
            try jpeg.write(to: destination, options: .atomic)
        } else {
            try data.write(to: destination, options: .atomic)
        }
        return filename
    }

    func load(filename: String?) -> UIImage? {
        guard let filename else { return nil }
        print("filename: \(filename)")
        let url = folderURL.appendingPathComponent(filename)
        return UIImage(contentsOfFile: url.path)
    }

    func delete(filename: String?) {
        guard let filename else { return }
        try? FileManager.default.removeItem(at: folderURL.appendingPathComponent(filename))
    }
}
