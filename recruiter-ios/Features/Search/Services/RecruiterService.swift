import Foundation

class RecruiterService: ObservableObject {
    @Published var recruiters: [Recruiter] = []
    @Published var isLoading = false
    
    func fetchRecruiters() async {
        isLoading = true
        defer { isLoading = false }
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Dummy data
        recruiters = [
            Recruiter(id: "1", company: "Tech Corp", rating: 4.5, headquarters: "San Francisco, CA", industry: "Technology", verified: true, reviewCount: 42, averageRating: 4.5),
            Recruiter(id: "2", company: "Startup Inc", rating: 4.8, headquarters: "New York, NY", industry: "Software", verified: true, reviewCount: 31, averageRating: 4.8),
            Recruiter(id: "3", company: "Big Tech", rating: 4.2, headquarters: "Seattle, WA", industry: "Technology", verified: false, reviewCount: 25, averageRating: 4.2),
            Recruiter(id: "4", company: "Dev Solutions", rating: 4.7, headquarters: "Austin, TX", industry: "Consulting", verified: true, reviewCount: 18, averageRating: 4.7)
        ]
    }
}
