import Foundation
import Combine

@MainActor
class MainViewModel: ObservableObject {
    @Published var books: [Book] = []
    private var currentPage = 1
    private var totalPages = 1
    var isLoading = false
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchBooks() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let wrapper = try await networkManager.fetch(from: BooksEndpoint()) as BookDataWrapper
            totalPages = Int(ceil(Double(wrapper.count) / Double(wrapper.results.count)))
            books.append(contentsOf: wrapper.results)
        } catch {
            print("Failed to fetch books: \(error.localizedDescription)")
        }
    }

    func fetchNextIfNeeded(currentBook: Book) async {
        guard currentPage < totalPages else { return }
        guard let lastBook = books.last, lastBook.id == currentBook.id else { return }
        
        isLoading = true
        defer { isLoading = false }

        do {
            let wrapper = try await networkManager.fetch(from: BooksNextEndpoint(page:currentPage + 1)) as BookDataWrapper
            currentPage += 1
            totalPages = Int(ceil(Double(wrapper.count) / Double(wrapper.results.count)))
            books.append(contentsOf: wrapper.results)
        } catch {
            print("Failed to fetch books: \(error.localizedDescription)")
        }
    }

}
