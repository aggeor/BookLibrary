@testable import BookLibrary
import Foundation
struct MockEndpoint: Endpoint {
    var baseURL: URL {
        URL(string: "https://example.com")!
    }
    
    var path: String {
        "/books"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var parameters: [String : Any]? {
        nil
    }
}
