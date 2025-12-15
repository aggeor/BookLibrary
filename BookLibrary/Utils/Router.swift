import SwiftUI
import Combine

enum Route: Identifiable {
    case bookDetails(Book)
    
    var id: String {
        switch self {
        case .bookDetails(let book):
            return "bookDetails_\(book.id)"
        }
    }
}

class Router: ObservableObject {
    @Published var currentRoute: Route?
    @Published var isPresented: Bool = false
    
    func navigate(to route: Route) {
        currentRoute = route
        isPresented = true
    }
    
    func dismiss() {
        isPresented = false
        self.currentRoute = nil
    }
}

extension Router {
    @ViewBuilder
    func getDestinationView() -> some View {
        if let route = currentRoute {
            switch route {
            case .bookDetails(let book):
                BookDetailsView(book: book)
            }
        }
    }
}
