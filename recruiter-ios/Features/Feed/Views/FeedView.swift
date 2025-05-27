import SwiftUI

struct FeedView: View {
    @StateObject private var feedService = FeedService()
    
    var body: some View {
        NavigationStack {
            Group {
                if feedService.isLoading {
                    ProgressView()
                } else if let error = feedService.error {
                    VStack {
                        Text("Error loading feed")
                            .foregroundStyle(.secondary)
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                        Button("Retry") {
                            Task {
                                await feedService.fetchFeed()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(feedService.feedItems) { review in
                                FeedReviewCard(review: review)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Feed")
        }
        .task {
            await feedService.fetchFeed()
        }
    }
}

struct FeedReviewCard: View {
    let review: FeedReview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(review.author)
                    .font(.headline)
                Spacer()
                Text(review.date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Text(review.content)
                .font(.body)
                .padding(.vertical, 4)
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text(String(format: "%.1f", review.rating))
                    .font(.subheadline.bold())
                
                Spacer()
                
                if review.wasHelpful > 0 {
                    Text("\(review.wasHelpful) found helpful")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        )
    }
}
