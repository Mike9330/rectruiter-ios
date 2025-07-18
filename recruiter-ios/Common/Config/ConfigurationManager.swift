import Foundation

struct ConfigurationManager {
    static var apiBaseURL: String {
        // First try to get from Info.plist (when xcconfig is properly configured)
        if let baseURL = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String {
            return baseURL
        }
        
        // Temporary fallback until xcconfig is set up
        print("⚠️ WARNING: Using hardcoded API URL. Please configure xcconfig files!")
        return "https://recruiter-api-staging.up.railway.app"
    }
    
    static var apiSecretKey: String {
        // First try to get from Info.plist (when xcconfig is properly configured)
        if let secretKey = Bundle.main.object(forInfoDictionaryKey: "API_SECRET_KEY") as? String {
            return secretKey
        }
        
        // Temporary fallback until xcconfig is set up
        print("⚠️ WARNING: Using hardcoded API key. Please configure xcconfig files!")
        return "JeikT2EEbvKflszx5T_YsxiEp7byCYLHKxdlyqmqdBo"
    }
}