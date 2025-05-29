import Foundation

struct OnboardingItem: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
}

extension OnboardingItem {
    static let items = [
        OnboardingItem(
            image: "star.square.fill",
            title: "Read Reviews",
            description: "Get honest feedback about recruiters from other job seekers"
        ),
        OnboardingItem(
            image: "rectangle.and.pencil.and.ellipsis",
            title: "Share Your Experience",
            description: "Help others by sharing your recruiting experiences"
        ),
        OnboardingItem(
            image: "magnifyingglass",
            title: "Find Recruiters",
            description: "Search and discover verified recruiters in your industry"
        )
    ]
}