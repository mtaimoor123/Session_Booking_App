//
//  Data Manager.swift
//  PumpkinPal
//
//  Created by Munib Hamza on 10/04/2023.
//

import Foundation

class DataManager {
    private init() {}
    static let shared = DataManager()
    
    func saveUserToDefaults(_ user: User) {
        UserDefaults.standard.setValue(true, forKey: Constants.isLoggedIn)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: Constants.userKey)
        UserDefaults.standard.synchronize()
    }
    
    
    func readUserData() -> User? {
        
        var customer: User?
        if let data = UserDefaults.standard.value(forKey: Constants.userKey) as? Data {
            customer = try! PropertyListDecoder().decode(User.self, from: data)
        }
        
        return customer
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.value(forKey: Constants.authToken) as? String
    }
    
    func saveAccessToken(token : String) {
        UserDefaults.standard.setValue(token, forKey: Constants.authToken)
    }
    
    func isIntroDone() -> Bool? {
        return UserDefaults.standard.value(forKey: Constants.isIntroDone) as? Bool
    }
    
    func isIntroDone(_ status : Bool) {
        UserDefaults.standard.set(status,forKey: Constants.isIntroDone)
    }
    
    func logoutUser() {
        UserDefaults.standard.setValue(false, forKey: Constants.isLoggedIn)
        UserDefaults.standard.setValue(nil, forKey: Constants.userKey)
        UserDefaults.standard.setValue(nil, forKey: Constants.authToken)
    }
    
//    func getFCM() -> String {
//        return UserDefaults.standard.value(forKey: "FCMToken") as? String ?? ""
//    }
    
    func getUsername() -> String {
        let user = readUserData()
        return user?.username ?? ""
    }
    
    func getName() -> String {
        let user = readUserData()
        return (user?.firstName ?? "") + (user?.lastName ?? "")
    }
    
    func getUserId() -> Int {
        let user = readUserData()
        return user?.id ?? -1
    }
    
    
    func deleteUserModel() {
        let user = User()
        saveUserToDefaults(user)
        UserDefaults.standard.setValue(false, forKey: Constants.isLoggedIn)
        print("user data deleted")
    }
    
}
