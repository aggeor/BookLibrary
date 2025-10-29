import SwiftUI

struct FavoriteButton: View{
    let book: Book
    @EnvironmentObject var favoritesManager: FavoritesManager
    var body: some View {
        Button(action: {
            favoritesManager.toggleFavorite(book)
        }) {
            Image(systemName: favoritesManager.isFavorite(book) ? "heart.fill" : "heart")
                .foregroundColor(.red)
                .padding(6)
                .background(Color.black.opacity(0.5))
                .clipShape(Circle())
                .padding(4)
        }
    }
}
