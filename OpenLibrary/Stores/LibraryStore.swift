import Foundation
import Observation

@Observable
final class LibraryStore {
    private(set) var books: [Book] = []

    func contains(_ book: Book) -> Bool {
        books.contains { $0.id == book.id }
    }

    func add(_ book: Book) {
        guard !contains(book) else { return }
        books.append(book)
    }

    func remove(_ book: Book) {
        books.removeAll { $0.id == book.id }
    }
}
