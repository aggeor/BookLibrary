import XCTest
@testable import BookLibrary

final class MainViewModelTests: XCTestCase {
    var viewModel: MainViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = MainViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    @MainActor
    func testFetchBooksLoadsBooks() async throws {
        await viewModel.fetchBooks()
        XCTAssertFalse(viewModel.books.isEmpty)
        XCTAssertEqual(viewModel.books.first?.title, "Book 1")
    }
    
    @MainActor
    func testFetchNextIfNeededTriggersPagination() async throws {
        await viewModel.fetchBooks()
        let lastBook = viewModel.books.last!
        await viewModel.fetchNextIfNeeded(currentBook: lastBook)
        XCTAssertTrue(mockNetworkManager.didFetchNextPage)
    }
}
