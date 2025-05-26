import Foundation

class UserService: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoading = false
    
    private let baseURL = "https://recruiter-api-staging.up.railway.app"
    private let apiKey = "JeikT2EEbvKflszx5T_YsxiEp7byCYLHKxdlyqmqdBo"
    
    struct LoginRequest: Codable {
        let email: String
        let password: String
    }
    
    struct LoginResponse: Codable {
        let message: String
        let email: String
    }
    
    struct ErrorResponse: Codable {
        let detail: String
    }
    
    func signIn(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: "\(baseURL)/users/signin") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "API_SECRET_KEY")
        
        let loginRequest = LoginRequest(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(loginRequest)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: errorResponse.detail])
        }
        
        let response = try JSONDecoder().decode(LoginResponse.self, from: data)
        
        await MainActor.run {
            self.currentUser = User(
                id: UUID().uuidString,
                name: "Anonymous",
                email: response.email,
                title: "User",
                company: "Unknown"
            )
        }
    }
    
    func signUp(name: String, email: String, title: String, company: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // TODO: Replace with actual API call
        currentUser = User(
            id: UUID().uuidString,
            name: name,
            email: email,
            title: title,
            company: company
        )
    }
    
    func signOut() {
        currentUser = nil
    }
}
