import Foundation

struct BooksEndpoint: Endpoint {
    let page: Int

    var baseURL: URL {
        URL(string: "https://gutendex.com")!
    }

    var path: String {
        "/books"
    }

    var method: HTTPMethod {
        .get
    }

    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }

    var parameters: [String : Any]? {
        [
            "page": page
        ]
    }
}
