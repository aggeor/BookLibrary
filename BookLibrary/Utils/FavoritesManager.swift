import Foundation
import Combine

@MainActor
class FavoritesManager: ObservableObject {
    @Published var favoriteBooks: [Book] = []
    
    func isFavorite(_ book: Book) -> Bool {
        favoriteBooks.contains(where: { $0.id == book.id })
    }
    
    func toggleFavorite(_ book: Book) {
        if let index = favoriteBooks.firstIndex(where: { $0.id == book.id }) {
            favoriteBooks.remove(at: index)
        } else {
            favoriteBooks.append(book)
        }
    }
}
