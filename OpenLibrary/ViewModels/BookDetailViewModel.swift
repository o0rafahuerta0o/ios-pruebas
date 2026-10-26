import Foundation
import Observation

@Observable
final class BookDetailViewModel {
    let book: Book

    init(book: Book) {
        self.book = book
    }

    var pagesText: String { book.pages.map { String($0) } ?? "—" }
    var languageText: String { book.language ?? "—" }
    var yearText: String { book.year.map { String($0) } ?? "—" }
    var synopsisText: String { book.synopsis ?? "Sin sinopsis disponible" }

    func isSaved(in library: LibraryStore) -> Bool {
        library.contains(book)
    }

    func toggleSaved(in library: LibraryStore) {
        if library.contains(book) {
            library.remove(book)
        } else {
            library.add(book)
        }
    }
}
