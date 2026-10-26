import SwiftUI

struct HomeView: View {
    @AppStorage(StorageKey.username) private var savedUsername = ""

    var body: some View {
        VStack(spacing: 14) {
            Text("Open Library")
                .font(.title2.bold())

            Text("Hola, \(savedUsername)")
                .font(.headline)

            Text("Bienvenido a OpenLibrary, en donde podrás buscar y encontrar cualquier libro que quieras")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Button("Cerrar sesión") {
                savedUsername = ""
            }
            .font(.footnote)
            .padding(.top, 20)

            Spacer()
        }
        .padding(.horizontal, 28)
        .padding(.top, 50)
    }
}

#Preview { HomeView() }
