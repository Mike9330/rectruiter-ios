import Foundation

@MainActor
class ReviewViewModel: ObservableObject {
    @Published var recruiterNames: [String] = []
    @Published var selectedRecruiter = "new"
    @Published var newRecruiterName = ""
    @Published var rating = 0
    @Published var reviewText = ""
    @Published var showSuccessAlert = false
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    private let namesApiURL = "https://recruiter-api-staging.up.railway.app/recruiters/getAllRecruiterNames"
    private let apiKey = "JeikT2EEbvKflszx5T_YsxiEp7byCYLHKxdlyqmqdBo"
    
    var canSubmit: Bool {
        if selectedRecruiter == "new" {
            return !newRecruiterName.isEmpty && rating > 0 && !reviewText.isEmpty
        }
        return rating > 0 && !reviewText.isEmpty
    }
    
    func fetchRecruiterNames() async {
        guard let url = URL(string: namesApiURL) else { return }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "API_SECRET_KEY")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let json = String(data: data, encoding: .utf8) {
                print("Raw API Response (Names):", json)
            }
            
            let names = try JSONDecoder().decode([String].self, from: data)
            self.recruiterNames = names
        } catch {
            print("Error fetching recruiter names:", error)
        }
    }
    
    func submitReview() async {
        guard canSubmit else {
            errorMessage = "Please fill in all required fields"
            showErrorAlert = true
            return
        }
        
        // TODO: Implement API call to submit review
        // For now, just show success
        showSuccessAlert = true
        
        // Reset form
        rating = 0
        reviewText = ""
        if selectedRecruiter == "new" {
            newRecruiterName = ""
        }
    }
}
