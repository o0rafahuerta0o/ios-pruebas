import SwiftUI

struct BookList: View {
    let books: [Book]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        BookCard(book: book)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
