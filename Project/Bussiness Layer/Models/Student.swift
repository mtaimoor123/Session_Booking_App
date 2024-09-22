
struct Student: Codable {

    var asDictionary: [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.compactMap { (label: String?, value: Any) -> (String, Any)? in
            guard let label = label else { return nil }

            // Unwrap the value if it's optional, otherwise keep it as is
            if let optionalValue = value as? OptionalProtocol, let unwrappedValue = optionalValue.wrappedValue {
                // Remove the key if the unwrapped value is an empty string
                if let stringValue = unwrappedValue as? String, stringValue.isEmpty {
                    return nil
                }
                return (label, unwrappedValue)
            } else if let stringValue = value as? String, stringValue.isEmpty {
                // Handle non-optional but empty string values
                return nil
            }

            // Ensure we don't add any nil values to the dictionary
            if value is Optional<Any> {
                return nil
            }
            
            if value is OptionalProtocol {
                return nil
            }

            return (label, value)
        })
        return dict
    }
    
    var id: Int?
    var username: String?
    var password: String?
    var confrim_password: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var emailSecond: String?
    var dob: String?
    var gender: String?
    var image: String?
    var phone: String?
    var phoneSecond: String?
    var idInput: String?
    var department: String?
    var position: String?
    var isDepartmentHod: Int?  // 0 or 1
    var address: String?
    var joiningDate: String?
    var userRole: Int?  // 0 or 1
    var registerDate: String?
    var userType: Int?
    var status: Int?

}

protocol OptionalProtocol {
    var wrappedValue: Any? { get }
}

extension Optional: OptionalProtocol {
    var wrappedValue: Any? {
        switch self {
        case .none: return nil
        case .some(let value): return value
        }
    }
}

// MARK: - RegisterAccount
struct RegisterAccount {
    let login: Bool?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass {
    let id: Int?
    let username, firstName, lastName, email: String?
    let registerDate: String?
    let userType, status: Int?
    let student: Students?
}

// MARK: - Student
struct Students {
}

// MARK: - UserSignup
struct UserSignup {
    var username: String?
    var firstName: String?
    var lastName: String?
    var gender: String?
    var country: String?
    var phoneNo: String?
    var secondaryPhoneNo: String?
    var email: String?
    var confirmEmail: String?
    var secondaryEmail: String?
    var password: String?
    var confirmPassword: String?
}
