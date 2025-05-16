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
            Group {
                if let user = userService.currentUser {
                    // Logged in view
                    VStack(alignment: .leading, spacing: 20) {
                        ProfileRow(title: "Name", value: user.name)
                        ProfileRow(title: "Email", value: user.email)
                        ProfileRow(title: "Title", value: user.title)
                        ProfileRow(title: "Company", value: user.company)
                        
                        Spacer()
                        
                        Button("Sign Out", role: .destructive) {
                            userService.signOut()
                        }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                } else {
                    // Sign in/up view
                    VStack(spacing: 20) {
                        if showingSignUp {
                            // Sign up form
                            Form {
                                Section {
                                    TextField("Name", text: $name)
                                    TextField("Email", text: $email)
                                    TextField("Title", text: $title)
                                    TextField("Company", text: $company)
                                }
                                
                                Section {
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
                                        if isSigningUp {
                                            ProgressView()
                                                .frame(maxWidth: .infinity)
                                        } else {
                                            Text("Sign Up")
                                                .frame(maxWidth: .infinity)
                                        }
                                    }
                                    .disabled(isSigningUp)
                                }
                            }
                        } else {
                            // Sign in form
                            Form {
                                Section {
                                    TextField("Email", text: $email)
                                    SecureField("Password", text: .constant(""))
                                }
                                
                                Section {
                                    Button("Sign In") {
                                        // TODO: Implement sign in
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        
                        Button(showingSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up") {
                            showingSignUp.toggle()
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
    }
}
