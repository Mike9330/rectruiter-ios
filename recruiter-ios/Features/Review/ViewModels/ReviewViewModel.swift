import Foundation

@MainActor
class ReviewViewModel: ObservableObject {
    @Published var userService: UserService
    
    // Keep existing properties
    @Published var headquarters = ""
    @Published var selectedIndustry = "Technology"
    let industries = [
        "Technology",
        "Healthcare",
        "Finance",
        "Education",
        "Manufacturing",
        "Retail",
        "Consulting",
        "Entertainment",
        "Real Estate",
        "Energy"
    ]
    @Published var recruiterNames: [String] = []
    @Published var selectedRecruiter = "new"
    @Published var newRecruiterName = ""
    @Published var rating = 0
    @Published var reviewText = ""
    @Published var showSuccessAlert = false
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    private let reviewedRecruitersKey = "userReviewedRecruiters"
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    // Keep existing URLs
    private let namesApiURL = "https://recruiter-api-staging.up.railway.app/recruiters/getAllRecruiterNames"
    private let apiKey = "JeikT2EEbvKflszx5T_YsxiEp7byCYLHKxdlyqmqdBo"
    private let baseURL = "https://recruiter-api-staging.up.railway.app/recruiters"
    
    var canSubmit: Bool {
        if selectedRecruiter == "new" {
            return !newRecruiterName.isEmpty && rating > 0 && !reviewText.isEmpty && !headquarters.isEmpty
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
    
    private func submitNewRecruiter() async throws {
        guard let url = URL(string: "\(baseURL)/addRecruiter") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "API_SECRET_KEY")
        
        let review = NewReview(
            author: userService.currentUser?.name ?? "Anonymous",
            date: ISO8601DateFormatter().string(from: Date()),
            rating: Double(rating),
            content: reviewText,
            wasHelpful: 0
        )
        
        let newRecruiter = NewRecruiter(
            company: newRecruiterName,
            rating: Double(rating),
            headquarters: headquarters,
            industry: selectedIndustry,
            verified: false,
            reviewcount: 1,
            averagerating: Float(rating),
            reviews: [review]
        )
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(newRecruiter)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        if let json = String(data: data, encoding: .utf8) {
            print("Response:", json)
        }
    }
    
    private func addReviewToExisting() async throws {
        guard let url = URL(string: "\(baseURL)/addReview/\(selectedRecruiter)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "API_SECRET_KEY")
        
        let review = ExistingReview(
            id: UUID().uuidString,
            author: userService.currentUser?.name ?? "Anonymous",
            date: ISO8601DateFormatter().string(from: Date()),
            rating: Double(rating),
            content: reviewText,
            washelpful: 0
        )
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(review)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        if let json = String(data: data, encoding: .utf8) {
            print("Response:", json)
        }
    }
    
    private func hasUserReviewed(_ recruiterName: String) -> Bool {
        let reviewedRecruiters = UserDefaults.standard.stringArray(forKey: reviewedRecruitersKey) ?? []
        return reviewedRecruiters.contains(recruiterName)
    }
    
    private func markRecruiterAsReviewed(_ recruiterName: String) {
        var reviewedRecruiters = UserDefaults.standard.stringArray(forKey: reviewedRecruitersKey) ?? []
        reviewedRecruiters.append(recruiterName)
        UserDefaults.standard.set(reviewedRecruiters, forKey: reviewedRecruitersKey)
    }
    
    func submitReview() async {
        guard canSubmit else {
            errorMessage = "Please fill in all required fields"
            showErrorAlert = true
            return
        }
        
        let recruiterName = selectedRecruiter == "new" ? newRecruiterName : selectedRecruiter
        if hasUserReviewed(recruiterName) {
            errorMessage = "You have already reviewed this recruiter"
            showErrorAlert = true
            return
        }
        
        do {
            if selectedRecruiter == "new" {
                try await submitNewRecruiter()
            } else {
                try await addReviewToExisting()
            }
            
            markRecruiterAsReviewed(recruiterName)
            
            showSuccessAlert = true
            
            // Keep existing reset code...
            rating = 0
            reviewText = ""
            if selectedRecruiter == "new" {
                newRecruiterName = ""
                headquarters = ""
                selectedIndustry = "Technology"
            }
        } catch {
            errorMessage = "Error submitting review: \(error)"
            showErrorAlert = true
        }
    }
    
    struct NewReview: Encodable {
        let author: String
        let date: String
        let rating: Double
        let content: String
        let wasHelpful: Int
    }

    struct NewRecruiter: Encodable {
        let company: String
        let rating: Double
        let headquarters: String
        let industry: String
        let verified: Bool
        let reviewcount: Int
        let averagerating: Float
        let reviews: [NewReview]
    }

    struct ExistingReview: Encodable {
        let id: String
        let author: String
        let date: String
        let rating: Double
        let content: String
        let washelpful: Int
    }
}
