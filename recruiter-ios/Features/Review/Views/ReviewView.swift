import SwiftUI

struct ReviewView: View {
    @StateObject private var viewModel = ReviewViewModel()
    @EnvironmentObject var userService: UserService
    @FocusState private var isFocused: Bool
    
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
                // Login required message
                VStack(spacing: 20) {
                    Image(systemName: "person.fill.questionmark")
                        .font(.system(size: 60))
                        .foregroundStyle(.gray)
                        .padding(.bottom, 20)
                    
                    Text("Sign In Required")
                        .font(.title2.bold())
                    
                    Text("Please sign in using the Profile tab to write reviews")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    
                    TabView {
                        Text("")
                    }
                    .tabViewStyle(.page)
                    .frame(height: 50)
                    .overlay(
                        HStack {
                            Spacer()
                            VStack(spacing: 4) {
                                Image(systemName: "person.fill")
                                Text("Profile")
                                    .font(.caption)
                            }
                            .foregroundStyle(.blue)
                            Spacer()
                        }
                    )
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
    }
}
