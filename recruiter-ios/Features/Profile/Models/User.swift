import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: String
    var name: String
    var email: String
    var title: String
    var company: String
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
