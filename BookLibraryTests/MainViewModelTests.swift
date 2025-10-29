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
        
        XCTAssertFalse(viewModel.books.isEmpty, "Books should not be empty after fetch.")
        XCTAssertEqual(viewModel.books.first?.title, "Book 1", "First book title should match mock.")
        XCTAssertEqual(viewModel.books.count, 1, "There should be exactly 1 book in mock response.")
    }
    
    @MainActor
    func testFetchNextIfNeededTriggersPagination() async throws {
        await viewModel.fetchBooks()
        let lastBook = viewModel.books.last!
        
        await viewModel.fetchNextIfNeeded(currentBook: lastBook)
        
        XCTAssertTrue(mockNetworkManager.didFetchNextPage, "Pagination should trigger when last book is reached.")
        XCTAssertEqual(viewModel.books.count, 2, "Books count should increase after pagination.")
    }
    
    @MainActor
    func testFetchBooksHandlesEmptyResponse() async throws {
        mockNetworkManager.shouldReturnEmpty = true
        
        await viewModel.fetchBooks()
        
        XCTAssertTrue(viewModel.books.isEmpty, "Books should be empty if network returns empty response.")
    }
    
    @MainActor
    func testCurrentPageIncrementsCorrectly() async throws {
        XCTAssertEqual(viewModel.books.count, 0)
        
        await viewModel.fetchBooks()
        XCTAssertEqual(viewModel.books.count, 1)
        
        let lastBook = viewModel.books.last!
        await viewModel.fetchNextIfNeeded(currentBook: lastBook)
        XCTAssertEqual(viewModel.books.count, 2)
    }
    
    @MainActor
    func testInitialLoadingStateDuringFetch() async throws {
        // Before fetch
        XCTAssertFalse(viewModel.isInitialLoading, "Initial loading should start as false")
        
        // Start fetch
        Task{
            await viewModel.fetchBooks()
        }
        // Small delay to ensure fetchBooks is running
        try await Task.sleep(nanoseconds: 10_000_000) // 10ms
        
        // While fetch is running, isInitialLoading should be true
        XCTAssertTrue(viewModel.isInitialLoading, "Initial loading should be true during fetch")
        
        // Small delay to ensure fetchBooks is running
        try await Task.sleep(nanoseconds: 150_000_000) // 10ms
        
        // After fetch
        XCTAssertFalse(viewModel.isInitialLoading, "Initial loading should be false after fetch completes")
    }

    @MainActor
    func testPaginationLoadingStateDuringFetchNext() async throws {
        await viewModel.fetchBooks()
        let lastBook = viewModel.books.last!
        
        // Before pagination
        XCTAssertFalse(viewModel.isPaginationLoading, "Pagination loading should start as false")
        
        Task{
            await viewModel.fetchNextIfNeeded(currentBook: lastBook)
        }
        // Small delay to ensure fetchBooks is running
        try await Task.sleep(nanoseconds: 10_000_000) // 10ms
        
        // While pagination fetch is running
        XCTAssertTrue(viewModel.isPaginationLoading, "Pagination loading should be true during fetchNextIfNeeded")
        
        // Small delay to ensure fetchBooks is running
        try await Task.sleep(nanoseconds: 150_000_000) // 10ms
        
        XCTAssertFalse(viewModel.isPaginationLoading, "Pagination loading should be false after fetchNextIfNeeded completes")
    }

    @MainActor
    func testFetchBooksHandlesErrorGracefully() async throws {
        mockNetworkManager.shouldThrowError = true
        
        await viewModel.fetchBooks()
        
        XCTAssertTrue(viewModel.books.isEmpty, "Books should remain empty if fetch throws an error")
        XCTAssertFalse(viewModel.isInitialLoading, "Initial loading should be false after failed fetch")
    }

    @MainActor
    func testFetchNextIfNeededHandlesErrorGracefully() async throws {
        await viewModel.fetchBooks()
        let lastBook = viewModel.books.last!
        mockNetworkManager.shouldThrowError = true
        
        await viewModel.fetchNextIfNeeded(currentBook: lastBook)
        
        // Ensure books count did not change
        XCTAssertEqual(viewModel.books.count, 1, "Books count should remain unchanged if pagination fetch fails")
        XCTAssertFalse(viewModel.isPaginationLoading, "Pagination loading should be false after failed fetchNextIfNeeded")
    }

}
