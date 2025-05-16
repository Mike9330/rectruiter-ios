import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.top, 40)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredRecruiters) { recruiter in
                            RecruiterCard(recruiter: recruiter)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search recruiters...")
            .navigationTitle("Search")
        }
        .task {
            await viewModel.fetchRecruiters()
        }
    }
}

struct RecruiterCard: View {
    let recruiter: Recruiter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(recruiter.company)
                            .font(.headline)
                        if recruiter.verified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    Text(recruiter.industry)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(recruiter.headquarters)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
            }
            
            Divider()
            
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", recruiter.rating))
                        .fontWeight(.medium)
                }
                
                Text("•")
                    .foregroundStyle(.secondary)
                
                Text("\(recruiter.reviewCount) reviews")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Button {
                    // Add contact action
                } label: {
                    Text("Contact")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.blue)
                        .clipShape(Capsule())
                }
            }
            .font(.subheadline)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        )
    }
}
