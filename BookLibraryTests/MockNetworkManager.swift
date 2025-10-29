@testable import BookLibrary

final class MockNetworkManager: NetworkManaging {
    var didFetchNextPage = false
    var shouldReturnEmpty = false
    var shouldThrowError = false
    
    func fetch<T>(from endpoint: Endpoint) async throws -> T where T : Decodable {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 100_000_000) // 100ms
        // Simulate pagination
        if let booksEndpoint = endpoint as? BooksEndpoint {
            if booksEndpoint.page > 1 {
                didFetchNextPage = true
            }
        }

        if shouldReturnEmpty {
            let wrapper = BookDataWrapper(count: 0,next: nil, previous: nil, results: [])
            return wrapper as! T
        }

        if shouldThrowError {
            throw NetworkError.unknownError(500)
        }

        // Return mock data
        let mockBooks = [
            Book(
                id: 1,
                title: "Book 1",
                subjects: [],
                authors: [Person(name: "Author 1", birth_year: nil, death_year: nil)],
                summaries: [],
                translators: [],
                editors: [],
                bookshelves: [],
                languages: ["en"],
                copyright: nil,
                media_type: "text",
                formats: [:],
                download_count: 10,
            )
        ]
        let wrapper = BookDataWrapper(count: 10, next:nil,previous: nil, results: mockBooks)
        return wrapper as! T
    }
}
