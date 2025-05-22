import Foundation

struct Review: Identifiable {
    let id: String
    let author: String
    let date: Date
    let rating: Double
    let content: String
    let wasHelpful: Int
}