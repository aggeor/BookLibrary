import Foundation
import Combine

@MainActor
class MainViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var isInitialLoading = false
    @Published var isPaginationLoading = false
    private var currentPage = 1
    private var totalPages = 1
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging? = nil) {
        self.networkManager = networkManager ?? NetworkManager.shared
    }
    
    func fetchBooks() async {
        isInitialLoading = true
        defer { isInitialLoading = false }

        do {
            let response = try await networkManager.fetch(from: BooksEndpoint(page: currentPage)) as APIBooks
            totalPages = response.count
            let newBooks = response.results.map(Book.init)
            books.append(contentsOf: newBooks)
            currentPage += 1
        } catch {
            print("Failed to fetch books: \(error.localizedDescription)")
        }
    }

    func fetchNextIfNeeded(currentBook: Book) async {
        guard currentPage < totalPages else { return }
        guard let lastBook = books.last, lastBook.id == currentBook.id else { return }
        
        isPaginationLoading = true
        defer { isPaginationLoading = false }

        do {
            let response = try await networkManager.fetch(from: BooksEndpoint(page:currentPage)) as APIBooks
            totalPages = Int(ceil(Double(response.count) / Double(response.results.count)))
            let newBooks = response.results.map(Book.init)
            books.append(contentsOf: newBooks)
            currentPage += 1
        } catch {
            print("Failed to fetch books: \(error.localizedDescription)")
        }
    }

}
