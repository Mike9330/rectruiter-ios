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
                    // Auth Header
                    VStack(spacing: 8) {
                        Text(isSignUp ? "Create Account" : "Welcome Back")
                            .font(.title2.bold())
                        Text(isSignUp ? "Sign up to get started" : "Sign in to continue")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 32)
                    
                    if isSignUp {
                        // Sign up form
                        VStack(spacing: 16) {
                            AuthTextField(icon: "person.fill", placeholder: "Name", text: $name)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.words)
                            AuthTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                            AuthTextField(icon: "briefcase.fill", placeholder: "Job Title", text: $profession)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.words)
                            AuthTextField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)
                                .textFieldStyle(.roundedBorder)
                            
                            Button {
                                Task {
                                    isLoading = true
                                    do {
                                        try await userService.signUp(
                                            name: name,
                                            email: email,
                                            profession: profession,
                                            password: password
                                        )
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
                                        Text("Sign Up")
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .disabled(isLoading)
                        }
                    } else {
                        // Sign in form
                        VStack(spacing: 16) {
                            AuthTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                            AuthTextField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)
                                .textFieldStyle(.roundedBorder)
                            
                            Button {
                                Task {
                                    isLoading = true
                                    do {
                                        try await userService.signIn(
                                            email: email,
                                            password: password
                                        )
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
                                        Text("Sign In")
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .disabled(isLoading)
                        }
                    }
                    
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
                        Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                    .font(.subheadline)
                    
                    if showError {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
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
