import SwiftUI

@main
struct BookLibrary: App {
    @StateObject var favoritesManager = FavoritesManager()
    @StateObject var themeManager = ThemeManager()
    @StateObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            TabsView()
                .environmentObject(favoritesManager)
                .environmentObject(themeManager)
                .environmentObject(router)
        }
    }
}

struct TabsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var router: Router
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                MainView()
            }
            .tabItem {
                Label("Books", systemImage: "book")
            }
            .tag(0)
            
            NavigationView {
                FavoritesView()
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
            .tag(1)
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(2)
        }
        .onAppear() {
            DispatchQueue.main.async {
                themeManager.updateTabBar(
                    backgroundColor: UIColor(themeManager.backgroundColor),
                    itemColor: UIColor(themeManager.textColor),
                    unselectedItemColor: UIColor(themeManager.textColor.opacity(0.5))
                )
            }
        }
        .onChange(of: themeManager.isDarkMode) { _ in
            DispatchQueue.main.async {
                themeManager.updateTabBar(
                    backgroundColor: UIColor(themeManager.backgroundColor),
                    itemColor: UIColor(themeManager.textColor),
                    unselectedItemColor: UIColor(themeManager.textColor.opacity(0.5))
                )
            }
        }
        .onChange(of: selectedTab) { _ in
            // Dismiss any presented route when switching tabs
            router.dismiss()
        }
    }
}
