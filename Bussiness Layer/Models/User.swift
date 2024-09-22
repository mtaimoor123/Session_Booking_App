//
//  User.swift
//  PumpkinPal
//
//  Created by Munib Hamza on 10/04/2023.
//

import Foundation

// MARK: - User
struct User: Codable {
    var id: Int?
    var username, firstName, lastName, email: String?
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }
    
    enum CodingKeys: String, CodingKey {
        case id, username
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
}

