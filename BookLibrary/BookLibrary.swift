import SwiftUI
import SwiftData

@main
struct BookLibrary: App {
    @StateObject var favoritesManager = FavoritesManager()
    @StateObject var mainViewModel: MainViewModel = MainViewModel()
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.black
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = .white // selected icon color
        UITabBar.appearance().unselectedItemTintColor = UIColor.white // unselected icons
    }
    var body: some Scene {
        WindowGroup {
            TabView {
                MainView(mainViewModel: mainViewModel)
                    .tabItem {
                        Label("Books", systemImage: "book")
                    }
                
                FavoritesView(mainViewModel: mainViewModel)
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
            }
            .environmentObject(favoritesManager)
        }
    }
}
