import SwiftUI

struct BookDetailView: View {
    @State private var viewModel: BookDetailViewModel

    @Environment(LibraryStore.self) private var library
    @Environment(\.dismiss) private var dismiss

    init(book: Book) {
        _viewModel = State(initialValue: BookDetailViewModel(book: book))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                CoverPlaceholder(width: 130, height: 180, circle: 34)
                    .padding(.top, 22)

                Text(viewModel.book.title)
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                    .padding(.top, 18)
                    .padding(.horizontal, 20)
                Text(viewModel.book.author)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

                HStack {
                    stat("Páginas", viewModel.pagesText)
                    stat("Idioma", viewModel.languageText)
                    stat("Año de publicación", viewModel.yearText)
                }
                .padding(.vertical, 8)
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray5), lineWidth: 1))
                .padding(.horizontal, 20)
                .padding(.top, 18)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Sinopsis")
                        .font(.subheadline.weight(.bold))
                    Text(viewModel.synopsisText)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 18)

                saveButton
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle("Detalles")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3.weight(.semibold))
                }
            }
        }
    }

    @ViewBuilder
    private var saveButton: some View {
        if viewModel.isSaved(in: library) {
            Button {
                viewModel.toggleSaved(in: library)
            } label: {
                Text("Eliminar de mis libros")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.red)
            }
            .padding(.top, 26)
        } else {
            Button {
                viewModel.toggleSaved(in: library)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "bookmark")
                    Text("Guardarlo en mis libros")
                        .fontWeight(.semibold)
                }
                .font(.footnote)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(Color(red: 0.22, green: 0.25, blue: 0.32), in: RoundedRectangle(cornerRadius: 8))
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }

    private func stat(_ label: String, _ value: String) -> some View {
        VStack(spacing: 3) {
            Text(label)
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.footnote.weight(.bold))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        BookDetailView(book: Book.samples[0])
    }
    .environment(LibraryStore())
}
