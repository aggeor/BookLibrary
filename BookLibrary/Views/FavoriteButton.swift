import SwiftUI

struct FavoriteButton: View {
    let book: Book
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var themeManager: ThemeManager
    
    private var isFavorite: Bool {
        favoritesManager.isFavorite(book)
    }
    
    var body: some View {
        Button(action: {
            favoritesManager.toggleFavorite(book)
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(.red)
                .padding(6)
                .background(themeManager.backgroundColor.opacity(0.5))
                .clipShape(Circle())
                .padding(4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
