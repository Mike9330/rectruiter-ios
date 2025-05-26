import SwiftUI

struct ReviewView: View {
    @StateObject private var viewModel = ReviewViewModel()
    @EnvironmentObject var userService: UserService
    @FocusState private var isFocused: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningIn = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            if userService.currentUser != nil {
                // Review Form for authenticated users
                Form {
                    Section {
                        Picker("Select Recruiter", selection: $viewModel.selectedRecruiter) {
                            Text("New Recruiter").tag("new")
                            ForEach(viewModel.recruiterNames, id: \.self) { name in
                                Text(name).tag(name)
                            }
                        }
                        
                        if viewModel.selectedRecruiter == "new" {
                            TextField("New Recruiter Name", text: $viewModel.newRecruiterName)
                                .focused($isFocused)
                        }
                    }
                    
                    Section {
                        HStack(spacing: 8) {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: "star.fill")
                                    .font(.title2)
                                    .foregroundStyle(index <= viewModel.rating ? .yellow : .gray.opacity(0.3))
                                    .onTapGesture {
                                        viewModel.rating = index
                                    }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    Section {
                        TextEditor(text: $viewModel.reviewText)
                            .frame(minHeight: 100)
                            .focused($isFocused)
                            .overlay {
                                if viewModel.reviewText.isEmpty {
                                    Text("Write review here...")
                                        .foregroundStyle(.gray.opacity(0.8))
                                        .padding(.top, 8)
                                        .padding(.leading, 5)
                                        .allowsHitTesting(false)
                                }
                            }
                    }
                    
                    Section {
                        Button(action: {
                            Task {
                                isFocused = false
                                await viewModel.submitReview()
                            }
                        }) {
                            Text("Submit Review")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .disabled(!viewModel.canSubmit)
                        .buttonStyle(.borderedProminent)
                    }
                }
                .task {
                    await viewModel.fetchRecruiterNames()
                }
            } else {
                // Login form directly in ReviewView
                VStack(spacing: 24) {
                    Image(systemName: "person.fill.questionmark")
                        .font(.system(size: 60))
                        .foregroundStyle(.gray)
                        .padding(.bottom, 20)
                    
                    Text("Sign In Required")
                        .font(.title2.bold())
                    
                    Text("Please sign in to write a review")
                        .foregroundStyle(.secondary)
                    
                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.password)
                        
                        Button {
                            Task {
                                isSigningIn = true
                                do {
                                    try await userService.signIn(email: email, password: password)
                                } catch {
                                    errorMessage = error.localizedDescription
                                    showError = true
                                }
                                isSigningIn = false
                            }
                        } label: {
                            HStack {
                                if isSigningIn {
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
                        .disabled(isSigningIn)
                    }
                    .padding(.horizontal, 40)
                }
                .padding()
            }
        }
        .navigationTitle("Review")
        .alert("Success", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Your review has been submitted successfully!")
        }
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}
