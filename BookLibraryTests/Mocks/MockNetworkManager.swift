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
            let wrapper = APIBooks(count: 0,next: nil, previous: nil, results: [])
            return wrapper as! T
        }

        if shouldThrowError {
            throw NetworkError.unknownError(500)
        }

        // Return mock data
        let mockBooks = [
            APIBook(
                id: 1,
                title: "Book 1",
                subjects: [],
                authors: [APIPerson(name: "Author 1", birthYear: nil, deathYear: nil)],
                summaries: [],
                translators: [],
                editors: [],
                bookshelves: [],
                languages: ["en"],
                copyright: nil,
                mediaType: "text",
                formats: [:],
                downloadCount: 10,
            )
        ]
        let wrapper = APIBooks(count: 10, next:nil,previous: nil, results: mockBooks)
        return wrapper as! T
    }
}
