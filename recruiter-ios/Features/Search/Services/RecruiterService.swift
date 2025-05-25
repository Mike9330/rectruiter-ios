import Foundation

class RecruiterService: ObservableObject {
    @Published var recruiters: [Recruiter] = []
    @Published var isLoading = false
    
    private let apiURL = "https://recruiter-api-staging.up.railway.app/recruiters/getAllRecruiters"
    private let apiKey = "JeikT2EEbvKflszx5T_YsxiEp7byCYLHKxdlyqmqdBo"
    
    struct ErrorResponse: Codable {
        let detail: String
    }
    
    func fetchRecruiters() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: apiURL) else { 
            print("Invalid URL")
            return 
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "API_SECRET_KEY")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print("Response:", response)
            
            if let json = String(data: data, encoding: .utf8) {
                print("Raw API Response:", json)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // Try to decode error first
            if let error = try? decoder.decode(ErrorResponse.self, from: data) {
                print("API Error:", error.detail)
                return
            }
            
            let recruiters = try decoder.decode([Recruiter].self, from: data)
            print("Successfully decoded \(recruiters.count) recruiters")
            
            await MainActor.run {
                self.recruiters = recruiters
            }
        } catch {
            print("Error fetching recruiters:", error)
            dump(error) // More detailed error info
            
            // Fallback to dummy data if API fails
            await MainActor.run {
                self.recruiters = [
                    Recruiter(company: "Tech Corp", rating: 4.5, headquarters: "San Francisco, CA", industry: "Technology", verified: true, reviewCount: 42, averageRating: 4.5, reviewDTOs: []),
                    Recruiter(company: "Startup Inc", rating: 4.8, headquarters: "New York, NY", industry: "Software", verified: true, reviewCount: 31, averageRating: 4.8, reviewDTOs: []),
                    Recruiter(company: "Big Tech", rating: 4.2, headquarters: "Seattle, WA", industry: "Technology", verified: false, reviewCount: 25, averageRating: 4.2, reviewDTOs: []),
                    Recruiter(company: "Dev Solutions", rating: 4.7, headquarters: "Austin, TX", industry: "Consulting", verified: true, reviewCount: 18, averageRating: 4.7, reviewDTOs: [])
                ]
            }
        }
    }
}
