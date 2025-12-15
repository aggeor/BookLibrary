import XCTest
@testable import BookLibrary

final class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    var mockSession: URLSession!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
        networkManager = NetworkManager(session: mockSession)
    }
    
    override func tearDown() {
        networkManager = nil
        mockSession = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    
    @MainActor
    func testFetchSuccessfullyDecodesValidJSON() async throws {
        let mockBook = APIBook(
            id: 1,
            title: "Test Book",
            subjects: ["Fiction"],
            authors: [APIPerson(name: "Test Author", birthYear: 1950, deathYear: 2000)],
            summaries: ["A test summary"],
            translators: [],
            editors: [],
            bookshelves: [],
            languages: ["en"],
            copyright: false,
            mediaType: "text",
            formats: ["text/html": "https://example.com"],
            downloadCount: 100
        )
        
        let mockWrapper = APIBooks(
            count: 1,
            next: nil,
            previous: nil,
            results: [mockBook]
        )
        
        let mockData = try JSONEncoder().encode(mockWrapper)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockData)
        }
        
        let endpoint = MockEndpoint()
        let result: APIBooks = try await networkManager.fetch(from: endpoint)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.results.first?.title, "Test Book")
        XCTAssertEqual(result.results.first?.id, 1)
    }
    
    @MainActor
    func testFetchHandles200StatusCode() async throws {
        let mockData = try createMockBookWrapperData()
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, mockData)
        }
        
        let endpoint = MockEndpoint()
        let result: APIBooks = try await networkManager.fetch(from: endpoint)
        
        XCTAssertNotNil(result)
    }
    
    // MARK: - Error Tests
    
    @MainActor
    func testFetchThrowsInvalidResponseError() async {
        // Configure MockURLProtocol to throw an error that will prevent HTTPURLResponse casting
        MockURLProtocol.shouldReturnInvalidResponse = true
        MockURLProtocol.requestHandler = { request in
            // This will be ignored when shouldReturnInvalidResponse is true
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        
        let endpoint = MockEndpoint()
        
        do {
            let _: APIBooks = try await networkManager.fetch(from: endpoint)
            XCTFail("Should have thrown invalidResponse error")
        } catch let error as NetworkError {
            if case .invalidResponse = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    @MainActor
    func testFetchThrowsDecodingFailedError() async {
        let invalidJSON = "{ invalid json }".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, invalidJSON)
        }
        
        let endpoint = MockEndpoint()
        
        do {
            let _: APIBooks = try await networkManager.fetch(from: endpoint)
            XCTFail("Should have thrown decodingFailed error")
        } catch let error as NetworkError {
            if case .decodingFailed = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    @MainActor
    func testFetchThrowsClientError400() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        
        let endpoint = MockEndpoint()
        
        do {
            let _: APIBooks = try await networkManager.fetch(from: endpoint)
            XCTFail("Should have thrown clientError")
        } catch let error as NetworkError {
            if case .clientError(let statusCode) = error {
                XCTAssertEqual(statusCode, 400)
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    @MainActor
    func testFetchThrowsClientError404() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        
        let endpoint = MockEndpoint()
        
        do {
            let _: APIBooks = try await networkManager.fetch(from: endpoint)
            XCTFail("Should have thrown clientError")
        } catch let error as NetworkError {
            if case .clientError(let statusCode) = error {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    @MainActor
    func testFetchThrowsServerError500() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        
        let endpoint = MockEndpoint()
        
        do {
            let _: APIBooks = try await networkManager.fetch(from: endpoint)
            XCTFail("Should have thrown serverError")
        } catch let error as NetworkError {
            if case .serverError(let statusCode) = error {
                XCTAssertEqual(statusCode, 500)
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    @MainActor
    func testFetchThrowsServerError503() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 503,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        
        let endpoint = MockEndpoint()
        
        do {
            let _: APIBooks = try await networkManager.fetch(from: endpoint)
            XCTFail("Should have thrown serverError")
        } catch let error as NetworkError {
            if case .serverError(let statusCode) = error {
                XCTAssertEqual(statusCode, 503)
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    @MainActor
    func testFetchThrowsUnknownError() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 600,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        
        let endpoint = MockEndpoint()
        
        do {
            let _: APIBooks = try await networkManager.fetch(from: endpoint)
            XCTFail("Should have thrown unknownError")
        } catch let error as NetworkError {
            if case .unknownError(let statusCode) = error {
                XCTAssertEqual(statusCode, 600)
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    
    func testNetworkErrorDescriptions() {
        let invalidResponseError = NetworkError.invalidResponse
        XCTAssertEqual(invalidResponseError.errorDescription, "Invalid response received from the server.")
        
        let decodingError = NetworkError.decodingFailed
        XCTAssertEqual(decodingError.errorDescription, "Failed to decode the response data.")
        
        let clientError = NetworkError.clientError(404)
        XCTAssertEqual(clientError.errorDescription, "Client error occurred. Status code: 404")
        
        let serverError = NetworkError.serverError(500)
        XCTAssertEqual(serverError.errorDescription, "Server error occurred. Status code: 500")
        
        let unknownError = NetworkError.unknownError(999)
        XCTAssertEqual(unknownError.errorDescription, "An unknown error occurred. Status code: 999")
    }
    
    @MainActor
    private func createMockBookWrapperData() throws -> Data {
        let mockBook = APIBook(
            id: 1,
            title: "Test",
            subjects: [],
            authors: [],
            summaries: [],
            translators: [],
            editors: [],
            bookshelves: [],
            languages: ["en"],
            copyright: false,
            mediaType: "text",
            formats: [:],
            downloadCount: 0
        )
        
        let wrapper = APIBooks(
            count: 1,
            next: nil,
            previous: nil,
            results: [mockBook]
        )
        
        return try JSONEncoder().encode(wrapper)
    }
}
