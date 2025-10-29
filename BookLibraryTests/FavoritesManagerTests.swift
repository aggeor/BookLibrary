import XCTest
@testable import BookLibrary

final class FavoritesManagerTests: XCTestCase {
    
    var favoritesManager: FavoritesManager!
    var sampleBook: Book!
    
    @MainActor
    override func setUp() {
        super.setUp()
        favoritesManager = FavoritesManager()
        sampleBook = Book(
            id: 1,
            title: "Sample Book",
            subjects: [],
            authors: [Person(name: "John Doe", birth_year: nil, death_year: nil)],
            summaries: [],
            translators: [],
            editors: [],
            bookshelves: [],
            languages: ["en"],
            copyright: nil,
            media_type: "text",
            formats: [:],
            download_count: 100,
        )
        
    }
    
    override func tearDown() {
        favoritesManager = nil
        sampleBook = nil
        super.tearDown()
    }
    
    @MainActor
    func testToggleFavoriteAddsBook() {
        favoritesManager.toggleFavorite(sampleBook)
        XCTAssertTrue(favoritesManager.isFavorite(sampleBook))
    }
    
    @MainActor
    func testToggleFavoriteRemovesBook() {
        favoritesManager.toggleFavorite(sampleBook)
        favoritesManager.toggleFavorite(sampleBook)
        XCTAssertFalse(favoritesManager.isFavorite(sampleBook))
    }
    
    @MainActor
    func testIsFavoriteReturnsFalseForNonFavorite() {
        XCTAssertFalse(favoritesManager.isFavorite(sampleBook))
    }
    
    @MainActor
    func testFavoritesListContainsAddedBook() {
        favoritesManager.toggleFavorite(sampleBook)
        XCTAssertTrue(favoritesManager.favoriteBooks.contains(sampleBook.id))
    }
}
