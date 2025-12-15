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
            authors: [Person(name: "John Doe", birthYear: nil, deathYear: nil)],
            authorNames: "John Doe",
            imageURL: nil,
            summary: "",
            summaries: [],
            subjects: [],
            languages: [],
            downloadCount: 0,
            isCopyrighted: nil,
            translators: [],
            editors: [],
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
        XCTAssertTrue(favoritesManager.favoriteBooks.contains(sampleBook))
    }
}
