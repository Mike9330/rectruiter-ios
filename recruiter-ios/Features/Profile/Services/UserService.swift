import Foundation

class UserService: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoading = false
    
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
