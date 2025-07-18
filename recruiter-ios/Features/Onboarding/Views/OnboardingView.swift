import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    @State private var showAuth = false
    @EnvironmentObject var userService: UserService
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(Array(OnboardingItem.items.enumerated()), id: \.element.id) { index, item in
                GeometryReader { geometry in
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
                            VStack(spacing: 16) {
                                Button {
                                    showAuth = true
                                } label: {
                                    Text("Sign In or Create Account")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(.blue)
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                
                                Button {
                                    withAnimation {
                                        hasSeenOnboarding = true
                                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                                    }
                                } label: {
                                    Text("Continue as Guest")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        Spacer()
                            .frame(height: geometry.safeAreaInsets.bottom + 100)
                    }
                    .padding()
                    .frame(width: geometry.size.width)
                }
                .tag(index)
            }
        }
        .sheet(isPresented: $showAuth) {
            AuthView()
                .environmentObject(userService)
        }
        .onChange(of: userService.currentUser) { user in
            if user != nil {
                withAnimation {
                    hasSeenOnboarding = true
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                }
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
