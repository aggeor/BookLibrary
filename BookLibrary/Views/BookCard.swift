import SwiftUI
struct BookCard: View {
    var book: Book
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .top) {
            if let imageURL = book.imageURL {
                imageView(url: imageURL)
            } else {
                Color.gray
                    .aspectRatio(0.67, contentMode: .fit)
                    .cornerRadius(12)
            }
            textsView
            FavoriteButton(book: book)
        }
        .frame(height: 120)
        .contentShape(Rectangle())
    }
    
    func imageView(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 80, height: 120)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 120)
                    .clipped()
            case .failure:
                Color.gray
                    .frame(width: 80, height: 120)
            @unknown default:
                EmptyView()
            }
        }
        .cornerRadius(12)
    }
    
    var textsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(book.title)
                .foregroundColor(themeManager.textColor)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .lineLimit(3)
            let authorNames = book.authorNames
            if !authorNames.isEmpty {
                Text(authorNames)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(themeManager.secondaryTextColor)
                    .lineLimit(3)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
    }
}
