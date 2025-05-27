import Foundation

struct FeedReview: Codable, Identifiable {
    var id: String {
        "\(rawId ?? UUID().uuidString)"
    }
    
    private let rawId: String?
    let date: String
    let author: String
    let rating: Double
    let content: String
    let wasHelpful: Int
    
    enum CodingKeys: String, CodingKey {
        case rawId = "id"
        case date
        case author
        case rating
        case content
        case wasHelpful = "washelpful"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle both String and Int cases for id
        if let stringId = try? container.decode(String.self, forKey: .rawId) {
            self.rawId = stringId
        } else if let intId = try? container.decode(Int.self, forKey: .rawId) {
            self.rawId = String(intId)
        } else {
            self.rawId = nil
        }
        
        self.date = try container.decode(String.self, forKey: .date)
        self.author = try container.decode(String.self, forKey: .author)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.content = try container.decode(String.self, forKey: .content)
        
        // Try both washelpful and wasHelpful keys
        if let helpful = try? container.decodeIfPresent(Int.self, forKey: .wasHelpful) {
            self.wasHelpful = helpful
        } else {
            self.wasHelpful = 0  // Default to 0 if key doesn't exist
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rawId, forKey: .rawId)
        try container.encode(date, forKey: .date)
        try container.encode(author, forKey: .author)
        try container.encode(rating, forKey: .rating)
        try container.encode(content, forKey: .content)
        try container.encode(wasHelpful, forKey: .wasHelpful)
    }
}
