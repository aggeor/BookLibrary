import SwiftUI

struct BookDetailsView: View {
    let book: Book
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    
    private let headerHeight: CGFloat = 250
    
    init(book: Book) {
        self.book = book
        // Transparent navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            headerView
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 8) {
                    Color.clear.frame(height: headerHeight)
                    
                    textsView
                }
            }
        }
        .background(themeManager.backgroundColor)
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backBtnView
                    .tint(themeManager.textColor)
            }
            ToolbarItem(placement: .topBarTrailing) {
                FavoriteButton(book: book)
            }
        }
    }
    
    var headerView: some View {
        ZStack {
            if let imageURL = book.imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        placeholderHeader
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        placeholderHeader
                    @unknown default:
                        placeholderHeader
                    }
                }
            } else {
                placeholderHeader
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: headerHeight)
        .overlay(headerGradient)
        .clipped()
    }

    var placeholderHeader: some View {
        Color.gray
    }

    var headerGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                themeManager.backgroundColor.opacity(0.0),
                themeManager.backgroundColor
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 100)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    var backBtnView: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
        }
    }
    
    var textsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            infoView()
            subjectsView()
            
            dividerView
            
            if let summary = book.summary,
               !summary.isEmpty {
                Text(summary)
                    .font(.body)
                    .foregroundColor(themeManager.textColor)
            }
            dividerView
            
            moreInfoView()
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .frame(maxWidth: .infinity)
        .background(themeManager.backgroundColor)
        .cornerRadius(32)
    }
    
    func infoView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(book.title)
                .font(.title)
                .bold()
                .foregroundColor(themeManager.textColor)
            let authors = book.authors
            if !authors.isEmpty {
                let authorDetails = authors.map { author in
                    var name = author.name
                    if let birth = author.birthYear, let death = author.deathYear {
                        name += " (\(birth) – \(death))"
                    } else if let birth = author.birthYear {
                        name += " (b. \(birth))"
                    } else if let death = author.deathYear {
                        name += " (d. \(death))"
                    }
                    return name
                }.joined(separator: ", ")

                Text(authorDetails)
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
                    .lineLimit(3)
            }
        }
    }
    
    func subjectsView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                let subjects = book.subjects
                if !subjects.isEmpty {
                    ForEach(subjects, id: \.self) { subject in
                        Text(subject)
                            .font(.subheadline)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    func moreInfoView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            let translators = book.translators
            if !translators.isEmpty {
                let translatorDetails = translators.map { translator in
                    var name = translator.name
                    if let birth = translator.birthYear, let death = translator.deathYear {
                        name += " (\(birth) – \(death))"
                    } else if let birth = translator.birthYear {
                        name += " (b. \(birth))"
                    } else if let death = translator.deathYear {
                        name += " (d. \(death))"
                    }
                    return name
                }.joined(separator: ", ")

                Text("Translators: \(translatorDetails)")
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
                    .lineLimit(3)
            }
            let editors = book.editors
            if !editors.isEmpty {
                let editorDetails = editors.map { editor in
                    var name = editor.name
                    if let birth = editor.birthYear, let death = editor.deathYear {
                        name += " (\(birth) – \(death))"
                    } else if let birth = editor.birthYear {
                        name += " (b. \(birth))"
                    } else if let death = editor.deathYear {
                        name += " (d. \(death))"
                    }
                    return name
                }.joined(separator: ", ")

                Text("Editors: \(editorDetails)")
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
                    .lineLimit(3)
            }
            let languages = book.languages
            if !languages.isEmpty {
                let readableLanguages = languages.compactMap { code in
                    Locale.current.localizedString(forLanguageCode: code)
                }.joined(separator: ", ")

                if !readableLanguages.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: "globe")
                            .foregroundColor(.gray)
                        Text("Languages: \(readableLanguages)")
                            .font(.subheadline)
                            .foregroundColor(themeManager.secondaryTextColor)
                            .lineLimit(3)
                    }
                }
            }
            
            HStack(spacing: 8) {
                Image(systemName: "arrow.down.square.fill")
                    .foregroundColor(.gray)
                Text("Downloads: \(String(book.downloadCount))")
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            if let copyright = book.isCopyrighted {
                HStack(spacing: 6) {
                    Image(systemName: copyright ? "lock.fill" : "book.fill")
                        .foregroundColor(copyright ? .red : .green)
                    Text(copyright ? "Copyrighted" : "Public Domain")
                        .font(.subheadline)
                        .foregroundColor(themeManager.secondaryTextColor)
                }
            }
        }
    }
    
    var dividerView: some View {
        Divider()
            .background(themeManager.dividerColor)
            .padding(.vertical, 8)
    }
}
