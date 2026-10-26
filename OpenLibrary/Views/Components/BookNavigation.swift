import SwiftUI

extension View {
    func bookNavigation() -> some View {
        self
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
            }
    }
}
