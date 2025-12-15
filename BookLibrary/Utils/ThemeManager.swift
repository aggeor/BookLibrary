import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        // Default to dark mode if not set
        if UserDefaults.standard.object(forKey: "isDarkMode") == nil {
            self.isDarkMode = true
        }
    }
    
    var backgroundColor: Color {
        isDarkMode ? .black : .white
    }
    
    var textColor: Color {
        isDarkMode ? .white : .black
    }
    
    var secondaryTextColor: Color {
        isDarkMode ? Color.white.opacity(0.8) : Color.black.opacity(0.6)
    }
    
    var cardBackgroundColor: Color {
        isDarkMode ? Color(white: 0.1) : Color(white: 0.95)
    }
    
    var dividerColor: Color {
        isDarkMode ? .gray : Color(white: 0.8)
    }
    
    func updateTabBar(backgroundColor: UIColor, itemColor: UIColor, unselectedItemColor: UIColor) {
        let appearance = createTabBarAppearance(
            backgroundColor: backgroundColor,
            itemColor: itemColor,
            unselectedItemColor: unselectedItemColor
        )
        
        // Get all window scenes
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.compactMap { $0 as? UIWindowScene }
        
        // Update tab bars in all windows
        for windowScene in windowScenes {
            for window in windowScene.windows {
                window.allSubviews.forEach { subview in
                    if let tabBar = subview as? UITabBar {
                        tabBar.standardAppearance = appearance
                        tabBar.scrollEdgeAppearance = appearance
                    }
                }
            }
        }
    }
    
    private func createTabBarAppearance(backgroundColor: UIColor, itemColor: UIColor, unselectedItemColor: UIColor) -> UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = unselectedItemColor
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedItemColor]
        itemAppearance.selected.iconColor = itemColor
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: itemColor]
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        return appearance
    }
}

// Helper extension to get all subviews
extension UIView {
    var allSubviews: [UIView] {
        var subs = self.subviews
        for subview in self.subviews {
            subs.append(contentsOf: subview.allSubviews)
        }
        return subs
    }
}
