import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var profession = ""
    @Published var password = ""
    @Published var isSigningUp = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func signUp() async {
        isSigningUp = true
        defer { isSigningUp = false }
        
        do {
            try await userService.signUp(
                name: name,
                email: email,
                profession: profession,
                password: password
            )
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
