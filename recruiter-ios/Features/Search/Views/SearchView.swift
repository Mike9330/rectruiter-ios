import SwiftUI
@_implementationOnly import struct recruiter_ios.Review

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
                            NavigationLink(value: recruiter) {
                                RecruiterCard(recruiter: recruiter)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search recruiters...")
            .navigationTitle("Search")
            .navigationDestination(for: Recruiter.self) { recruiter in
                RecruiterDetailView(recruiter: recruiter)
            }
        }
        .task {
            await viewModel.fetchRecruiters()
        }
    }
}

struct RecruiterCard: View {
    let recruiter: Recruiter
    @Environment(\.colorScheme) var colorScheme
    
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
                    .foregroundStyle(.secondary)
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
                .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.05), radius: 8, y: 2)
        )
    }
}

struct RecruiterDetailView: View {
    let recruiter: Recruiter
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    HStack {
                        Text(recruiter.company)
                            .font(.title2.bold())
                        if recruiter.verified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    Text(recruiter.industry)
                        .foregroundStyle(.secondary)
                    
                    Text(recruiter.headquarters)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 16) {
                        VStack {
                            Text(String(format: "%.1f", recruiter.averageRating))
                                .font(.title.bold())
                            Text("Rating")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Divider()
                            .frame(height: 40)
                        
                        VStack {
                            Text("\(recruiter.reviewCount)")
                                .font(.title.bold())
                            Text("Reviews")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                        .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.05), radius: 8, y: 2)
                )
                
                // Reviews
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Reviews")
                        .font(.headline)
                    
                    ForEach(recruiter.reviews) { review in
                        ReviewCard(review: review)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Recruiter Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReviewCard: View {
    let review: Review
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(review.author)
                        .font(.headline)
                    Text(review.date, style: .date)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", review.rating))
                }
                .font(.subheadline)
            }
            
            Text(review.content)
                .font(.body)
            
            HStack {
                Image(systemName: "hand.thumbsup")
                Text("\(review.wasHelpful) found this helpful")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.05), radius: 8, y: 2)
        )
    }
}
