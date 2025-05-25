import Foundation
@_implementationOnly import struct recruiter_ios.Review

struct ReviewDTO: Codable {
    let date: String
    let author: String
    let rating: Double
    let content: String
    private let wasHelpfulUpper: Int?
    private let wasHelpfulLower: Int?
    
    var wasHelpful: Int {
        wasHelpfulUpper ?? wasHelpfulLower ?? 0
    }
    
    enum CodingKeys: String, CodingKey {
        case date, author, rating, content
        case wasHelpfulUpper = "wasHelpful"
        case wasHelpfulLower = "washelpful"
    }
    
    func toReview() -> Review {
        Review(
            id: "\(author)-\(date)", 
            author: author, 
            date: Date(), // TODO: Parse date properly
            rating: rating,
            content: content,
            wasHelpful: wasHelpful
        )
    }
}

struct Recruiter: Identifiable, Hashable, Codable {
    var company: String
    var rating: Double
    var headquarters: String
    var industry: String
    var verified: Bool
    var reviewCount: Int
    var averageRating: Float
    private var reviewDTOs: [ReviewDTO]
    
    init(company: String, rating: Double, headquarters: String, industry: String, verified: Bool, reviewCount: Int, averageRating: Float, reviewDTOs: [ReviewDTO]) {
        self.company = company
        self.rating = rating
        self.headquarters = headquarters
        self.industry = industry
        self.verified = verified
        self.reviewCount = reviewCount
        self.averageRating = averageRating
        self.reviewDTOs = reviewDTOs
    }
    
    var id: String { company }
    var reviews: [Review] { reviewDTOs.map { $0.toReview() } }
    
    enum CodingKeys: String, CodingKey {
        case company
        case rating
        case headquarters
        case industry
        case verified
        case reviewCount = "reviewcount"
        case averageRating = "averagerating"
        case reviewDTOs = "reviews"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(company)
    }
    
    static func == (lhs: Recruiter, rhs: Recruiter) -> Bool {
        lhs.company == rhs.company
    }
}
