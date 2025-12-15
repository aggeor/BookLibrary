import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var router: Router

    var favoriteBooks: [Book] {
        favoritesManager.favoriteBooks
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                if favoriteBooks.isEmpty {
                    emptyView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(favoriteBooks, id: \.id) { book in
                                Button {
                                    router.navigate(to: .bookDetails(book))
                                } label: {
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
            }
            .navigationBarHidden(true)
            .background(themeManager.backgroundColor.edgesIgnoringSafeArea(.all))
            
            NavigationLink(
                destination: router.getDestinationView(),
                isActive: $router.isPresented
            ) {
                EmptyView()
            }
            .hidden()
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
