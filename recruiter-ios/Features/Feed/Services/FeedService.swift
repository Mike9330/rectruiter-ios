import Foundation

class FeedService: ObservableObject {
    @Published var feedItems: [FeedReview] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let baseURL = ConfigurationManager.apiBaseURL
    private let apiKey = ConfigurationManager.apiSecretKey
    
    @MainActor
    func fetchFeed() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: "\(baseURL)/recruiters/getReviewsByNewest") else {
            self.error = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "API_SECRET_KEY")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            let reviews = try decoder.decode([FeedReview].self, from: data)
            self.feedItems = reviews.filter { $0.verified }
            self.error = nil
        } catch {
            print("Debug decode error: \(error)")
            self.error = error.localizedDescription
        }
    }
}