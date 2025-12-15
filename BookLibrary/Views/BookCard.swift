import SwiftUI

struct BookCard: View {
    var book: Book
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    // Adjust frame for each book card
    let frameWidth = UIScreen.main.bounds.width / 5
    let frameHeight = UIScreen.main.bounds.height / 8
    
    var body: some View {
        HStack(alignment: .top){
            if let imageURL = book.imageURL {
                imageView(url: imageURL)
            } else {
                Color.gray
                    .frame(width: frameWidth, height: frameHeight)
                    .cornerRadius(12)
            }
            textsView
            FavoriteButton(book: book)
                .environmentObject(favoritesManager)
        }
        .contentShape(Rectangle()) 
    }
    
    func imageView(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: frameWidth, height: frameHeight)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: frameWidth, height: frameHeight)
                    .clipped()
                    .cornerRadius(12)
            case .failure:
                Color.gray
                    .frame(width: frameWidth, height: frameHeight)
                    .cornerRadius(12)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    var textsView: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(book.title)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .lineLimit(3)
            let authorNames = book.authorNames
            if !authorNames.isEmpty {
                Text(authorNames)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(3)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
    }
}
