import Foundation
import Combine

@MainActor
class FavoritesManager: ObservableObject {
    @Published var favoriteBooks: Set<Int> = []
    
    func isFavorite(_ book: Book) -> Bool {
        favoriteBooks.contains(book.id)
    }
    
    func toggleFavorite(_ book: Book) {
        if isFavorite(book) {
            favoriteBooks.remove(book.id)
        } else {
            favoriteBooks.insert(book.id)
        }
    }
}
