import SwiftUI
import SwiftData

@main
struct BookLibraryApp: App {
    @StateObject var favoritesManager = FavoritesManager()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(favoritesManager)
        }
    }
}
