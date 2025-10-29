import SwiftUI

struct BookCard: View {
    var book: Book
    
    // Adjust frame for each book card
    let frameWidth = UIScreen.main.bounds.width / 5
    let frameHeight = UIScreen.main.bounds.height / 8
    
    var body: some View {
        HStack(alignment: .top){
            if let imageURLString = book.formats["image/jpeg"],
               let url = URL(string: imageURLString) {
                imageView(url: url)
            } else {
                Color.gray
                    .frame(width: frameWidth, height: frameHeight)
                    .cornerRadius(12)
            }
            textsView
            FavoriteButton(book: book)
        }
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
            if let authorNames = book.authors?.compactMap({ $0.name }).joined(separator: ", "),
               !authorNames.isEmpty {
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
