//
//  Constants.swift
//  MehandiApp
//
//  Created by Muaaz on 14/12/2023.
//

import Foundation

enum AppStoryboard : String {
    case Home
    case Main
    case ClassManagement
    case TeacherProfile
    case QuizManagement
    
    var id: String {
        return String(describing: self)
    }
}


internal struct AlertConstants {
  static let Error = "Error!"
  static let Alert = "Alert"
  static let DeviceType = "ios"
  static let Ok = "Ok"
  static let EmailNotValid = "Email is not valid."
  static let PhoneNotValid = "Phone number is not valid."
  static let EmailEmpty = "Email is empty."
  static let PhoneEmpty = "Phone number is empty"
  static let FirstNameEmpty = "First name is empty"
  static let LastNameEmpty = "Last name is empty"
  static let NameEmpty = "Name is empty"
  static let Empty = " is empty"
  static let PasswordsMisMatch = "Make sure your passwords match"
  static let LoginSuccess = "Login successful"
  static let SignUpSuccess = "Signup successful"
  static let emailPasswordInvalid = "Email or password is not valid"
  static let PasswordEmpty = "Password is empty"
  static let shortPassword = "Password must be atleast 6 digits"
  static let Success = "Success"
  static let notFoundUrl = "URL is not found!"
  static let UnknownError = "Unknown Erorr Occoured!"
  static let Logout = "Logout?"
  static let LogoutMsg = "Are you sure to Logout?"
}

struct Constants {
    static let studentKey = "studentData"
    static let isLoggedIn = "isLoggedIn"
    static let authToken = "authToken"
}



//internal struct AC {
//    
//    static let Error = "Error!"
//    static let Alert = "Alert"
//    static let DeviceType = "ios"
//    static let Ok = "Ok"
//    static let EmailNotValid = "Email is not valid."
//    static let PhoneNotValid = "Phone number is not valid."
//    static let EmailEmpty = "Email is empty."
//    static let PhoneEmpty = "Phone number is empty"
//    static let FirstNameEmpty = "First name is empty"
//    static let LastNameEmpty = "Last name is empty"
//    static let NameEmpty = "Name is empty"
//    static let Empty = " is empty"
//    static let PasswordsMisMatch = "Make sure your passwords match"
//    static let LoginSuccess = "Login successful"
//    static let SignUpSuccess = "Signup successful"
//    static let emailPasswordInvalid = "Email or password is not valid"
//    static let PasswordEmpty = "Password is empty"
//    static let shortPassword = "Password must be atleast 6 digits"
//    static let Success = "Success"
//    static let InternetNotReachable = "Your phone does not appear to be connected to the internet. Please connect and try again"
//    static let UserNameEmpty = "Username is empty"
//    static let TermsAndCondition = "Terms and conditions have not been accepted"
//    static let AllFieldNotFilled = "Make sure all fields are filled"
//    static let fieldCanBeEmpty = "This field can not be empty"
//    
//    static let SomeThingWrong = "Some thing went wrong. Please try again."
//    static let ParsingError = "Received data in wrong format"
//    static let SelectFromDropDown = "Please select value from Dropdown"
//}




