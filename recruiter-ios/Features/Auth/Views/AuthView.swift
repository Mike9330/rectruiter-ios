import SwiftUI

struct AuthView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userService: UserService
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var profession = ""
    @State private var isSignUp = false
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text(isSignUp ? "Create Account" : "Welcome Back")
                        .font(.title2.bold())
                        .padding(.top)
                    
                    Text(isSignUp ? 
                         "Sign up to share your experiences and help others find great recruiters" :
                         "Sign in to access your account and reviews")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    
                    VStack(spacing: 16) {
                        if isSignUp {
                            AuthTextField(icon: "person.fill", placeholder: "Name", text: $name)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.words)
                            
                            AuthTextField(icon: "briefcase.fill", placeholder: "Job Title", text: $profession)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.words)
                        }
                        
                        AuthTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                        
                        AuthTextField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.vertical)
                    
                    if showError {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                    
                    Button {
                        Task {
                            isLoading = true
                            do {
                                if isSignUp {
                                    try await userService.signUp(
                                        name: name,
                                        email: email,
                                        profession: profession,
                                        password: password
                                    )
                                } else {
                                    try await userService.signIn(
                                        email: email,
                                        password: password
                                    )
                                }
                                
                                if userService.currentUser != nil {
                                    dismiss()
                                }
                            } catch {
                                errorMessage = error.localizedDescription
                                showError = true
                            }
                            isLoading = false
                        }
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text(isSignUp ? "Create Account" : "Sign In")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(isLoading)
                    
                    Button {
                        withAnimation {
                            isSignUp.toggle()
                            email = ""
                            password = ""
                            name = ""
                            profession = ""
                            showError = false
                            errorMessage = ""
                        }
                    } label: {
                        Text(isSignUp ? 
                             "Already have an account? Sign in" : 
                             "Don't have an account? Sign up")
                            .foregroundStyle(.blue)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .alert(isSignUp ? "Sign Up Error" : "Sign In Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
}
