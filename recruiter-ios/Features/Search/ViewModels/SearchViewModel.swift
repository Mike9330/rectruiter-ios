import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var recruiters: [Recruiter] = []
    @Published var isLoading = false
    
    private let recruiterService = RecruiterService()
    
    var filteredRecruiters: [Recruiter] {
        if searchText.isEmpty {
            return recruiters
        }
        return recruiters.filter { recruiter in
            recruiter.company.localizedCaseInsensitiveContains(searchText) ||
            recruiter.industry.localizedCaseInsensitiveContains(searchText) ||
            recruiter.headquarters.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func fetchRecruiters() async {
        isLoading = true
        defer { isLoading = false }
        
        await recruiterService.fetchRecruiters()
        recruiters = recruiterService.recruiters
    }
}
