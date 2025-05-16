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
            Recruiter(id: "1", name: "John Smith", company: "Tech Corp", role: "Senior Technical Recruiter", rating: 4.5, reviewCount: 42),
            Recruiter(id: "2", name: "Sarah Johnson", company: "Startup Inc", role: "Lead Recruiter", rating: 4.8, reviewCount: 31),
            Recruiter(id: "3", name: "Mike Wilson", company: "Big Tech", role: "Engineering Recruiter", rating: 4.2, reviewCount: 25),
            Recruiter(id: "4", name: "Emma Brown", company: "Dev Solutions", role: "Technical Recruiter", rating: 4.7, reviewCount: 18)
        ]
    }
}
