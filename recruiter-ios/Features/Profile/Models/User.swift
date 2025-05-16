import Foundation

struct User: Codable, Identifiable {
    let id: String
    var name: String
    var email: String
    var title: String
    var company: String
}
