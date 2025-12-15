
struct APIBooks: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [APIBook]
}

struct APIBook: Codable {
    let id: Int
    let title: String
    let subjects: [String]?
    let authors: [APIPerson]?
    let summaries: [String]?
    let translators: [APIPerson]?
    let editors: [APIPerson]?
    let bookshelves: [String]?
    let languages: [String]?
    let copyright: Bool?
    let mediaType: String
    let formats: [String: String]
    let downloadCount: Int

    enum CodingKeys: String, CodingKey {
        case id, title, subjects, authors, summaries, translators, editors, bookshelves, languages, copyright, formats
        case mediaType = "media_type"
        case downloadCount = "download_count"
    }
}

struct APIPerson: Codable {
    let name: String
    let birthYear: Int?
    let deathYear: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case birthYear = "birth_year"
        case deathYear = "death_year"
    }
}

