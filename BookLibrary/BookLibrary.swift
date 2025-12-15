import SwiftUI
import SwiftData

@main
struct BookLibrary: App {
    @StateObject var favoritesManager = FavoritesManager()
    @StateObject var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            TabsView()
                .environmentObject(favoritesManager)
                .environmentObject(themeManager)
        }
    }
}
struct TabsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Books", systemImage: "book")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .onAppear(){
            DispatchQueue.main.async {
                themeManager.updateTabBar(
                    backgroundColor: UIColor(themeManager.backgroundColor),
                    itemColor: UIColor(themeManager.textColor),
                    unselectedItemColor: UIColor(themeManager.textColor.opacity(0.5))
                )
            }
        }
        .onChange(of: themeManager.isDarkMode) { _ in
            // Force tab bar to update when theme changes
            DispatchQueue.main.async {
                themeManager.updateTabBar(
                    backgroundColor: UIColor(themeManager.backgroundColor),
                    itemColor: UIColor(themeManager.textColor),
                    unselectedItemColor: UIColor(themeManager.textColor.opacity(0.5))
                )
            }
        }
    }    
}
