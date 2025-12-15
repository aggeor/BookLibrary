import SwiftUI
struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedBook: Book?
    @State private var isNavigating = false

    var favoriteBooks: [Book] {
        favoritesManager.favoriteBooks
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerView
                if favoriteBooks.isEmpty {
                    emptyView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(favoriteBooks, id: \.id) { book in
                                Button(action: {
                                    selectedBook = book
                                    isNavigating = true
                                }) {
                                    BookCard(book: book)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    .background(themeManager.backgroundColor.edgesIgnoringSafeArea(.all))
                }
                
                NavigationLink(
                    destination: Group {
                        if let book = selectedBook {
                            BookDetailsView(book: book)
                        }
                    },
                    isActive: $isNavigating
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationBarHidden(true)
            .background(themeManager.backgroundColor.edgesIgnoringSafeArea(.all))
        }
    }
    
    var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Favorite Books")
                    .font(.title2)
                    .foregroundColor(themeManager.textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
        .background(themeManager.backgroundColor)
    }
    
    var emptyView: some View {
        VStack(spacing: 0) {
            Text("No favorite books")
                .font(.title3)
                .foregroundColor(themeManager.textColor)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 12)
        .background(themeManager.backgroundColor)
    }
}
