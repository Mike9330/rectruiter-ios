import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ReviewView()
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

#Preview {
    ContentView()
        .environmentObject(UserService())
}
