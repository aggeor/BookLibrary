import SwiftUI

struct MainView: View {
    
    @StateObject var mainViewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerView
                if mainViewModel.isInitialLoading{
                    loadingView
                } else if mainViewModel.books.isEmpty {
                    emptyView
                } else {
                    booksView
                }
            }
            .navigationBarHidden(true)
            .task {
                if mainViewModel.books.isEmpty {
                    await mainViewModel.fetchBooks()
                }
            }
        }
        .navigationTitle("Books")
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Popular Books")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
        .background(Color.black)
    }
    
    
    var loadingView: some View{
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
    }
    
    var emptyView: some View{
        VStack(spacing: 0) {
            Text("No books found")
                .font(.title3)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 12)
        .background(Color.black)
    }
    
    var booksView: some View{
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                ForEach(mainViewModel.books, id: \.id) { book in
                    NavigationLink(destination: BookDetailsView(book: book)) {
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
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.2)
                            .padding(.vertical, 20)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
