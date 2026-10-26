import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }

            SearchView()
                .tabItem { Label("Buscar", systemImage: "magnifyingglass") }

            MyBooksView()
                .tabItem { Label("Mis libros", systemImage: "book") }
        }
    }
}

#Preview { MainTabView().environment(LibraryStore()) }
