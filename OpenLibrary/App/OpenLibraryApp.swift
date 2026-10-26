import SwiftUI

@main
struct OpenLibraryApp: App {
    @State private var library = LibraryStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(library)
        }
    }
}
