import SwiftUI

struct MainView: View {
    @StateObject var mainViewModel: MainViewModel = MainViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                if mainViewModel.isInitialLoading {
                    loadingView
                } else if mainViewModel.books.isEmpty {
                    emptyView
                } else {
                    booksView
                }
            }
            .onAppear {
                Task {
                    if mainViewModel.books.isEmpty {
                        await mainViewModel.fetchBooks()
                    }
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
                Text("Popular Books")
                    .font(.title2)
                    .foregroundColor(themeManager.textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
        .background(themeManager.backgroundColor)
    }
    
    var loadingView: some View {
        ZStack {
            themeManager.backgroundColor
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: themeManager.textColor))
                .scaleEffect(1.5)
        }
    }
    
    var emptyView: some View {
        VStack(spacing: 0) {
            Text("No books found")
                .font(.title3)
                .foregroundColor(themeManager.textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 12)
        .background(themeManager.backgroundColor)
    }
    
    var booksView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                ForEach(mainViewModel.books, id: \.id) { book in
                    Button {
                        router.navigate(to: .bookDetails(book))
                    } label: {
                        BookCard(book: book)
                            .onAppear {
                                Task {
                                    await mainViewModel.fetchNextIfNeeded(currentBook: book)
                                }
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                if mainViewModel.isPaginationLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: themeManager.textColor))
                            .scaleEffect(1.2)
                            .padding(.vertical, 20)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}
