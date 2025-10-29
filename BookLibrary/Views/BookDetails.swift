import SwiftUI

struct BookDetailsView: View {
    let book: Book
    @Environment(\.dismiss) private var dismiss
    
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
                    
                    textsView()
                        .padding(.horizontal, 24)
                    
                }
            }
        }
        .background(Color.black)
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backBtnView
                    .tint(.white)
            }
            ToolbarItem(placement: .topBarTrailing) {
                FavoriteButton(book: book)
            }
        }
    }
    
    var headerView: some View {
        ZStack {
            if let imageURLString = book.formats["image/jpeg"],
               let url = URL(string: imageURLString) {
                AsyncImage(url: url) { phase in
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
        .frame(width: UIScreen.main.bounds.width,height: headerHeight)
        .overlay(headerGradient)
        .clipped()
    }

    var placeholderHeader: some View {
        Color.gray
    }

    var headerGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black]),
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
    
    func textsView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            infoView()
            subjectsView()
            
            dividerView
            
            if let summaries = book.summaries?.compactMap({ $0 }).joined(separator: ", "),
               !summaries.isEmpty {
                Text(summaries)
                    .font(.body)
                    .foregroundColor(.white)
            }
            dividerView
            
            moreInfoView()
            
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .background(.black)
        .cornerRadius(32)
        .frame(width: UIScreen.main.bounds.width)
    }
    
    
    func infoView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(book.title).font(.title).bold().foregroundColor(.white)
            
            if let authors = book.authors, !authors.isEmpty {
                let authorDetails = authors.map { author in
                    var name = author.name
                    if let birth = author.birth_year, let death = author.death_year {
                        name += " (\(birth) – \(death))"
                    } else if let birth = author.birth_year {
                        name += " (b. \(birth))"
                    } else if let death = author.death_year {
                        name += " (d. \(death))"
                    }
                    return name
                }.joined(separator: ", ")

                Text(authorDetails)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(3)
            }
        }
    }
    
    func subjectsView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if let subjects = book.subjects,
                   !subjects.isEmpty {
                    ForEach(subjects, id: \.self) { subject in
                        Text(subject)
                            .font(.subheadline)
                            .foregroundColor(.white)
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
            if let translators = book.translators, !translators.isEmpty {
                let translatorDetails = translators.map { translator in
                    var name = translator.name
                    if let birth = translator.birth_year, let death = translator.death_year {
                        name += " (\(birth) – \(death))"
                    } else if let birth = translator.birth_year {
                        name += " (b. \(birth))"
                    } else if let death = translator.death_year {
                        name += " (d. \(death))"
                    }
                    return name
                }.joined(separator: ", ")

                Text("Translators: \(translatorDetails)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(3)
            }
            if let editors = book.editors, !editors.isEmpty {
                let editorDetails = editors.map { editor in
                    var name = editor.name
                    if let birth = editor.birth_year, let death = editor.death_year {
                        name += " (\(birth) – \(death))"
                    } else if let birth = editor.birth_year {
                        name += " (b. \(birth))"
                    } else if let death = editor.death_year {
                        name += " (d. \(death))"
                    }
                    return name
                }.joined(separator: ", ")

                Text("Editors: \(editorDetails)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(3)
            }
            if let languages = book.languages,
               !languages.isEmpty {
                let readableLanguages = languages.compactMap { code in
                    Locale.current.localizedString(forLanguageCode: code)
                }.joined(separator: ", ")

                if !readableLanguages.isEmpty {
                    
                    HStack(spacing:8){
                        Image(systemName: "globe")
                            .foregroundColor(.gray)
                        Text("Languages: \(readableLanguages)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(3)
                    }
                }
            }
            
            HStack(spacing:8){
                Image(systemName: "arrow.down.square.fill")
                    .foregroundColor(.gray)
                Text("Downloads: \(String(book.download_count))")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
            }
            if let copyright = book.copyright {
                HStack(spacing: 6) {
                    Image(systemName: copyright ? "lock.fill" : "book.fill")
                        .foregroundColor(copyright ? .red : .green)
                    Text(copyright ? "Copyrighted" : "Public Domain")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
    var dividerView:some View{
        Divider().background(Color.gray).padding(.vertical, 8)
    }
}
