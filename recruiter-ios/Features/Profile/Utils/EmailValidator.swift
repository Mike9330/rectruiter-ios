import Foundation

enum EmailValidationError: LocalizedError {
    case invalid
    
    var errorDescription: String? {
        switch self {
        case .invalid:
            return "Please enter a valid email address"
        }
    }
}

struct EmailValidator {
    static func validate(_ email: String) throws {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        guard emailPredicate.evaluate(with: email) else {
            throw EmailValidationError.invalid
        }
    }
}