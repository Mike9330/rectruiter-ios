import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var profession = ""
    @Published var isSignUp = false
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    let userService: UserService
    
    init(userService: UserService = UserService()) {
        self.userService = userService
    }
    
    func signIn() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await userService.signIn(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    func signUp() async {
        isLoading = true
        defer { isLoading = false }
        
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
    
    func resetFields() {
        email = ""
        password = ""
        name = ""
        profession = ""
        showError = false
        errorMessage = ""
    }
}
