import Foundation

struct Books {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Book]
}

struct Book: Identifiable, Hashable, Sendable {
    let id: Int
    let title: String
    let authors: [Person]
    let authorNames: String
    let imageURL: URL?
    let summary: String?
    let summaries: [String]
    let subjects: [String]
    let languages: [String]
    let downloadCount: Int
    let isCopyrighted: Bool?
    let translators: [Person]
    let editors: [Person]
}

struct Person: Hashable, Sendable {
    let name: String
    let birthYear: Int?
    let deathYear: Int?
}


extension Books {
    init(from response: APIBooks) {
        self.count = response.count
        self.next = response.next
        self.previous = response.previous
        self.results = response.results.map(Book.init)
    }
}

extension Book {
    nonisolated init(from response: APIBook) {
        self.id = response.id
        self.title = response.title
        self.authors = response.authors?.map(Person.init) ?? []
        self.authorNames = response.authors?.map(Person.init).compactMap({ $0.name }).joined(separator: ", ") ?? ""
        self.imageURL = response.formats["image/jpeg"].flatMap(URL.init)
        self.summary = response.summaries?.compactMap({ $0 }).joined(separator: ", ")
        self.summaries = response.summaries ?? []
        self.subjects = response.subjects ?? []
        self.languages = response.languages ?? []
        self.downloadCount = response.downloadCount
        self.isCopyrighted = response.copyright
        self.translators = response.translators?.map(Person.init) ?? []
        self.editors = response.editors?.map(Person.init) ?? []
    }
}

extension Person {
    nonisolated init(from response: APIPerson) {
        self.name = response.name
        self.birthYear = response.birthYear
        self.deathYear = response.deathYear
    }
}

