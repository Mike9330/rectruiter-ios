import Foundation

struct Recruiter: Identifiable {
    let id: String
    var company: String
    var rating: Double
    var headquarters: String
    var industry: String
    var verified: Bool
    var reviewCount: Int
    var averageRating: Float
}
