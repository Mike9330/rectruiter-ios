import Foundation

struct Recruiter: Identifiable, Hashable {
    let id: String
    var company: String
    var rating: Double
    var headquarters: String
    var industry: String
    var verified: Bool
    var reviewCount: Int
    var averageRating: Float
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Recruiter, rhs: Recruiter) -> Bool {
        lhs.id == rhs.id
    }
}
