import SwiftUI

@main
struct recruiter_iosApp: App {
    @StateObject private var userService = UserService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userService)
        }
    }
}
