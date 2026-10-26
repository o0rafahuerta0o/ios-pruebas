import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Busca algún libro")
                    .font(.title.bold())

                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Buscar por título o autor", text: $viewModel.query)
                        .font(.subheadline)
                        .submitLabel(.search)
                        .autocorrectionDisabled()
                        .onSubmit { Task { await viewModel.search() } }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.systemGray5), lineWidth: 1))

                content

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .bookNavigation()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Text("Escribe el título o el autor de un libro")
                .font(.footnote)
                .foregroundStyle(.secondary)

        case .loading:
            ProgressView("Cargando resultados")
                .frame(maxWidth: .infinity)
                .padding(.top, 30)

        case .loaded:
            if viewModel.results.isEmpty {
                Text("Sin resultados para \"\(viewModel.searchedText)\"")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                Text("Resultados encontrados")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                BookList(books: viewModel.results)
            }

        case .failed(let message):
            Text(message)
                .font(.footnote)
                .foregroundStyle(.red)
        }
    }
}

#Preview { SearchView().environment(LibraryStore()) }
