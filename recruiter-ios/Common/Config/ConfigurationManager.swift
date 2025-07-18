import Foundation

struct ConfigurationManager {
    static var apiBaseURL: String {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
            fatalError("API_BASE_URL not found in Info.plist. Please ensure your xcconfig file is properly configured.")
        }
        return baseURL
    }
    
    static var apiSecretKey: String {
        guard let secretKey = Bundle.main.object(forInfoDictionaryKey: "API_SECRET_KEY") as? String else {
            fatalError("API_SECRET_KEY not found in Info.plist. Please ensure your xcconfig file is properly configured.")
        }
        return secretKey
    }
}