import SwiftUI

struct RootView: View {
    @AppStorage(StorageKey.username) private var savedUsername = ""

    var body: some View {
        if savedUsername.isEmpty {
            LoginView()
        } else {
            MainTabView()
        }
    }
}

#Preview { RootView().environment(LibraryStore()) }
