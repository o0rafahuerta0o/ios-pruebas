import SwiftUI

struct MyBooksView: View {
    @Environment(LibraryStore.self) private var library

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Mis libros")
                    .font(.title.bold())
                    .padding(.top, 12)

                if library.books.isEmpty {
                    Text("Aún no has guardado libros")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                } else {
                    BookList(books: library.books)
                        .padding(.top, 30)
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .bookNavigation()
        }
    }
}

#Preview { MyBooksView().environment(LibraryStore()) }
