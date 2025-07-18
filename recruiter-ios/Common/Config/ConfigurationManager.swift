import Foundation

struct ConfigurationManager {
    static var apiBaseURL: String {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
            // Fallback to default if not found in Info.plist
            return "https://recruiter-api-staging.up.railway.app"
        }
        return baseURL
    }
    
    static var apiSecretKey: String {
        guard let secretKey = Bundle.main.object(forInfoDictionaryKey: "API_SECRET_KEY") as? String else {
            // Fallback to default if not found in Info.plist
            return "JeikT2EEbvKflszx5T_YsxiEp7byCYLHKxdlyqmqdBo"
        }
        return secretKey
    }
}