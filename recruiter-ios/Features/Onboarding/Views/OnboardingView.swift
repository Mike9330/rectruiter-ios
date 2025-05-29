import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(Array(OnboardingItem.items.enumerated()), id: \.element.id) { index, item in
                VStack(spacing: 32) {
                    Spacer()
                    
                    Image(systemName: item.image)
                        .font(.system(size: 80))
                        .foregroundStyle(.blue)
                    
                    VStack(spacing: 12) {
                        Text(item.title)
                            .font(.title.bold())
                        
                        Text(item.description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if index == OnboardingItem.items.count - 1 {
                        Button {
                            withAnimation {
                                hasSeenOnboarding = true
                                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                            }
                        } label: {
                            Text("Get Started")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding()
                .tag(index)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}