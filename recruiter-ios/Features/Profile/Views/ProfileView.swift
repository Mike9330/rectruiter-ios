import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userService: UserService
    @State private var name = ""
    @State private var email = ""
    @State private var title = ""
    @State private var company = ""
    @State private var isSigningUp = false
    @State private var showingSignUp = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let user = userService.currentUser {
                        // Profile Header
                        VStack(spacing: 16) {
                            Circle()
                                .fill(.gray.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay {
                                    Text(user.name.prefix(1))
                                        .font(.title.bold())
                                        .foregroundStyle(.gray)
                                }
                            
                            Text(user.name)
                                .font(.title2.bold())
                            
                            Text(user.title)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Text(user.company)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 32)
                        
                        // Profile Info
                        VStack(spacing: 20) {
                            InfoRow(icon: "envelope.fill", title: "Email", value: user.email)
                            InfoRow(icon: "briefcase.fill", title: "Company", value: user.company)
                            InfoRow(icon: "person.text.rectangle.fill", title: "Title", value: user.title)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white)
                                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                        )
                        .padding(.horizontal)
                        
                        Button("Sign Out", role: .destructive) {
                            userService.signOut()
                        }
                        .buttonStyle(.bordered)
                        .padding(.top, 32)
                    } else {
                        VStack(spacing: 24) {
                            // Auth Header
                            VStack(spacing: 8) {
                                Text(showingSignUp ? "Create Account" : "Welcome Back")
                                    .font(.title2.bold())
                                Text(showingSignUp ? "Sign up to get started" : "Sign in to continue")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 32)
                            
                            if showingSignUp {
                                // Sign up form
                                VStack(spacing: 16) {
                                    AuthTextField(icon: "person.fill", placeholder: "Name", text: $name)
                                    AuthTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                                    AuthTextField(icon: "briefcase.fill", placeholder: "Title", text: $title)
                                    AuthTextField(icon: "building.2.fill", placeholder: "Company", text: $company)
                                    
                                    Button {
                                        Task {
                                            isSigningUp = true
                                            defer { isSigningUp = false }
                                            try? await userService.signUp(
                                                name: name,
                                                email: email,
                                                title: title,
                                                company: company
                                            )
                                        }
                                    } label: {
                                        HStack {
                                            if isSigningUp {
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
                                    .disabled(isSigningUp)
                                }
                            } else {
                                // Sign in form
                                VStack(spacing: 16) {
                                    AuthTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                                    AuthTextField(icon: "lock.fill", placeholder: "Password", text: .constant(""), isSecure: true)
                                    
                                    Button {
                                        // TODO: Implement sign in
                                    } label: {
                                        Text("Sign In")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(.blue)
                                            .foregroundStyle(.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                            }
                            
                            Button(showingSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up") {
                                showingSignUp.toggle()
                            }
                            .buttonStyle(.plain)
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Profile")
            .scrollDismissesKeyboard(.immediately)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .frame(width: 32, height: 32)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body)
            }
            
            Spacer()
        }
    }
}

struct AuthTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .frame(width: 24)
                .foregroundStyle(.secondary)
            
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
