import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var title = ""
    @Published var company = ""
    @Published var isSigningUp = false
    
    @Published var userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    func signUp() async {
        guard !name.isEmpty, !email.isEmpty else { return }
        
        isSigningUp = true
        defer { isSigningUp = false }
        
        try? await userService.signUp(
            name: name,
            email: email,
            title: title,
            company: company
        )
    }
    
    func signOut() {
        userService.signOut()
    }
}
