import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.filteredRecruiters) { recruiter in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(recruiter.name)
                                .font(.headline)
                            Text(recruiter.company)
                                .font(.subheadline)
                            Text(recruiter.role)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                                Text(String(format: "%.1f", recruiter.rating))
                                Text("(\(recruiter.reviewCount))")
                                    .foregroundStyle(.secondary)
                            }
                            .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    }
                    .searchable(text: $viewModel.searchText, prompt: "Search recruiters...")
                }
            }
            .navigationTitle("Search")
        }
        .task {
            await viewModel.fetchRecruiters()
        }
    }
}
