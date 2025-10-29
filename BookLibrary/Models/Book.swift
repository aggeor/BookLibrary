import Foundation

struct BookDataWrapper: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Book]
}

struct Book: Hashable, Codable{
    let id: Int
    let title: String
    let subjects: [String]?
    let authors: [Person]?
    let summaries: [String]?
    let translators: [Person]?
    let editors: [Person]?
    let bookshelves: [String]?
    let languages: [String]?
    let copyright: Bool?
    let media_type: String
    let formats: [String: String]
    let download_count: Int
}

struct Person: Hashable, Codable{
    let name: String
    let birth_year: Int?
    let death_year: Int?
}
