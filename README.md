# BookLibrary

> A mobile app for discovering and exploring books from [gutendex.com](https://gutendex.com/).

[![Swift Version][swift-image]][swift-url]

Browse an extensive directory of books with high-quality covers and details including titles, authors, subjects, summaries, languages, translators, editors, download counts and copyright.  

Each book has a dedicated detail view showing comprehensive information. You can also like books and save them in favorites tab.


## Features

- Browse popular books.

- Add books to favorite list.

- View detailed information for each book:

  - Book cover image
  
  - Title

  - Subjects

  - Summaries

  - Languages
  
  - Translators

  - Editors

  - Download counts
  
  - Copyright


## Screenshots

| Main Books Tab | Favorites Tab | Book Details 1 | Book Details 2 | 
|----------------|---------------|----------------|--------------|
| <img width="200" alt="Simulator Screenshot - iPhone 13 - 2025-10-29 at 17 37 59" src="https://github.com/user-attachments/assets/66349c88-4038-4060-a1cb-ef2cf1a8f09a" /> | <img width="200" alt="Simulator Screenshot - iPhone 13 - 2025-10-29 at 17 38 20" src="https://github.com/user-attachments/assets/889eb04d-ad3c-4624-96b7-86b4047f22f7" /> | <img width="200" alt="Simulator Screenshot - iPhone 13 - 2025-10-29 at 17 38 47" src="https://github.com/user-attachments/assets/d9f8648c-16de-48f0-9d1a-50201f0ae015" /> | <img width="200" alt="Simulator Screenshot - iPhone 13 - 2025-10-29 at 17 38 53" src="https://github.com/user-attachments/assets/9ec17009-f30f-472f-90ca-54dacf5823cb" /> | 


## Requirements

This project was built using **Xcode 26.0.1** and **Swift 6.2**. Mac/macOS is required.

## Installation

1. Install Xcode
2. Clone repository using Xcode

```
git clone https://github.com/aggeor/BookLibrary.git
```

3. Create a simulator device to run the app
4. Run the app

## Architecture Layers

**Models**
- `Book.swift` - Core data models including `Book`, `BookDataWrapper`, and `Person`
- `BooksEndpoint.swift` - API endpoint configuration conforming to `Endpoint` protocol

**ViewModels**
- `MainViewModel.swift` - Manages book fetching and pagination state

**Views**
- `MainView.swift` - Main browsing interface with book grid
- `FavoritesView.swift` - Displays user's favorited books
- `BookDetails.swift` - Detailed view for individual books with scrollable sections
- `BookCard.swift` - Reusable book card component for grid display
- `FavoriteButton.swift` - Reusable button for adding/removing favorites

**Utils**
- `NetworkManager.swift` - Generic network layer with `NetworkManaging` protocol for dependency injection
- `FavoritesManager.swift` - Manages favorite books logic(no persistent storage, only session based)

### Data Flow
1. `MainView` observes `MainViewModel` state
2. `MainViewModel` uses `NetworkManager` to fetch books from the API
3. Books are displayed in a `LazyVGrid` using `BookCard` components
4. Users can tap books to see `BookDetails` or use `FavoriteButton` to save favorites
5. `FavoritesManager` handles favorite books
6. `FavoritesView` displays saved favorite books from `MainViewModel` and `FavoritesManager` with filtering

### Key Design Patterns
- **Protocol-Oriented Programming**: `NetworkManaging` and `Endpoint` protocols enable mocking for tests
- **Dependency Injection**: ViewModels accept protocol types rather than concrete implementations
- **Async/Await**: Modern Swift concurrency for network operations
- **ObservableObject**: SwiftUI state management with `@EnvironmentObject`, `@Published` and `@StateObject` properties

## Testing
Comprehensive unit tests are included using **XCTest** with dependency injection for network mocking.

### Test Suite

**NetworkManagerTests** (8 tests)
- Tests the network layer with `MockURLProtocol` for request interception
- Validates:
  - **Success cases**: Valid JSON decoding with complete book data, HTTP 200 status code
  - **Error cases**: Invalid response (non-HTTPURLResponse), decoding failures with malformed JSON
  - **HTTP error handling**: Client errors (400, 404), server errors (500, 503), unknown status codes (600)
  - **Error descriptions**: Localized error messages for all `NetworkError` cases
- Uses ephemeral(no persistent storage) `URLSession` configuration for isolated testing with `MockURLProtocol`

**MainViewModelTests** (8 tests)
- Tests the main screen logic for fetching books and pagination
- Uses `MockNetworkManager` implementing `NetworkManaging` protocol
- Validates:
  - **Book loading**: Initial fetch populates books array correctly
  - **Pagination**: `fetchNextIfNeeded(currentBook:)` triggers next page load when reaching last book
  - **Empty results**: Handles empty response from API gracefully
  - **Page tracking**: Current page increments correctly during pagination
  - **Loading states**: `isInitialLoading` true during first fetch, `isPaginationLoading` true during pagination
  - **Error handling**: Gracefully handles network errors in both initial fetch and pagination without crashing

**FavoritesManagerTests** (4 tests)
- Tests favorites persistence layer(no persistent storage, only session based)
- Validates:
  - **Adding favorites**: `toggleFavorite()` adds book to favorites
  - **Removing favorites**: Second `toggleFavorite()` call removes book from favorites
  - **Checking status**: `isFavorite()` returns false for non-favorited books
  - **Favorites list**: `favoriteBooks` contains correct book IDs after addition

### Test Mocks

**MockURLProtocol**
- Intercepts `URLSession` requests for `NetworkManager` testing
- Configurable request handler returns mock HTTP responses and data
- Supports simulating invalid responses (non-HTTPURLResponse) via `shouldReturnInvalidResponse` flag

**MockNetworkManager**
- Implements `NetworkManaging` protocol for `MainViewModel` testing
- Returns mock `BookDataWrapper` with sample books
- Simulates network delay (100ms) for realistic testing
- Configurable flags: `shouldReturnEmpty`, `shouldThrowError`, `didFetchNextPage`

**MockEndpoint**
- Simple `Endpoint` implementation for testing network requests
- Points to `example.com` with `GET` method

### Testing Strategy
- **Protocol-based mocking**: `NetworkManaging` protocol allows injecting `MockNetworkManager` in tests
- **Isolated tests**: Each test uses fresh instances with proper setup/teardown
- **Async/await testing**: Native Swift concurrency in XCTest async methods
- **Main actor isolation**: Proper handling of `@MainActor` requirements for Swift 6 concurrency
- **Loading state verification**: Tests check loading indicators during async operations with precise timing

## Credits

Used Swift with SwiftUI

Used [gutendex.com api](https://gutendex.com/)

Used [this](https://medium.com/@gokhanvaris/creating-a-network-manager-in-swiftui-with-clean-code-principles-d767a0e93a9a) article for network manager

## Contact
Aggelos Georgiadis – [LinkedIn](https://www.linkedin.com/in/aggelos-georgiadis-16a1b6189/) - [Github](https://github.com/aggeor/) – ag.gewr@gmail.com

[swift-image]:https://img.shields.io/badge/swift-6.2-orange.svg
[swift-url]: https://swift.org/
