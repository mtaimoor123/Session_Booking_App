//
//  Data Manager.swift
//  Project
//
//  Created by User on 10/04/2023.
//

import Foundation

class DataManager {
    private init() {}
    static let shared = DataManager()
    
    // Save Student to UserDefaults
    func saveStudentToDefaults(_ student: Student) {
        UserDefaults.standard.setValue(true, forKey: Constants.isLoggedIn)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(student), forKey: Constants.studentKey)
        UserDefaults.standard.synchronize()
    }
    
    // Read Student data from UserDefaults
    func readStudentData() -> Student? {
        var student: Student?
        if let data = UserDefaults.standard.value(forKey: Constants.studentKey) as? Data {
            student = try? PropertyListDecoder().decode(Student.self, from: data)
        }
        return student
    }
    
    // Retrieve access token
    func getAccessToken() -> String? {
        return UserDefaults.standard.value(forKey: Constants.authToken) as? String
    }
    
    
    // Save access token to UserDefaults
    func saveAccessToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: Constants.authToken)
    }

    // Logout user and clear data
    func logoutUser() {
        UserDefaults.standard.setValue(false, forKey: Constants.isLoggedIn)
        UserDefaults.standard.setValue(nil, forKey: Constants.studentKey)
        UserDefaults.standard.setValue(nil, forKey: Constants.authToken)
    }
    
    // Retrieve the student's username
    func getUsername() -> String {
        let student = readStudentData()
        return student?.username ?? ""
    }
    
    // Retrieve the student's full name
    func getName() -> String {
        let student = readStudentData()
        return (student?.firstName ?? "") + (student?.lastName ?? "")
    }
    
    // Retrieve the student's ID
    func getStudentId() -> Int {
        let student = readStudentData()
        return student?.id ?? -1
    }
    
    // Delete student model from UserDefaults
    func deleteStudentModel() {
        let student = Student()
        saveStudentToDefaults(student)
        UserDefaults.standard.setValue(false, forKey: Constants.isLoggedIn)
        print("student data deleted")
    }
}
