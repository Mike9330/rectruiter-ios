import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userService: UserService
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        if !hasSeenOnboarding {
            OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
        } else {
            TabView {
                FeedView()
                    .tabItem {
                        Label("Feed", systemImage: "newspaper.fill")
                    }
                
                ReviewView(userService: userService)
                    .tabItem {
                        Label("Review", systemImage: "pencil.circle.fill")
                    }
                
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
               
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
        }
    }
}
