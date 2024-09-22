//
//  PasswordVC.swift
//  Project
//
//  Created by Muaaz on 09/08/2024.
//
import UIKit
import Alamofire

class PasswordVC: BaseClass {
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var alertLbl: UILabel!
    
    var userSignup: UserSignup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.setLeftPaddingPoints(20)
        confirmPasswordTF.setLeftPaddingPoints(20)
        alertLbl.isHidden = true
        passwordTF.isSecureTextEntry = true
        confirmPasswordTF.isSecureTextEntry = true
    }
    
    @IBAction func showPaswrod(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTF.isSecureTextEntry = !sender.isSelected
        sender.setImage(UIImage(systemName: sender.isSelected ? "eye.slash" : "eye"), for: .normal)
    }
    
    @IBAction func showConfirmPaswrod(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        confirmPasswordTF.isSecureTextEntry = !sender.isSelected
        sender.setImage(UIImage(systemName: sender.isSelected ? "eye.slash" : "eye"), for: .normal)
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        guard let password = passwordTF.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTF.text, password == confirmPassword else {
            alertLbl.isHidden = false
            alertLbl.text = "Passwords do not match"
            return
        }
        guard password.count >= 8 else {
            self.hideActivityIndicator()
            showAlert(message: "Password is too short!")
            return
        }
        userSignup.password = password
        userSignup.confirmPassword = confirmPassword
        registerUser(userSignup: userSignup)
    }
    
    func registerUser(userSignup: UserSignup) {
        let parameters: Parameters = [
            "username": userSignup.username ?? "",
            "password": userSignup.password ?? "",
            "confrim_password": userSignup.confirmPassword ?? "",
            "first_name": userSignup.firstName ?? NSNull(),
            "last_name": userSignup.lastName ?? NSNull(),
            "email": userSignup.email ?? "",
            "email_second": userSignup.secondaryEmail ?? NSNull(),
            "DOB": NSNull(),
            "gender": userSignup.gender ?? NSNull(),
            "image": NSNull(),
            "phone": userSignup.phoneNo ?? NSNull(),
            "phone_second": userSignup.secondaryPhoneNo ?? NSNull(),
            "id_input": NSNull(),
            "skype": NSNull(),
            "address": NSNull(),
            "school": NSNull(),
            "school_name": NSNull(),
            "grade_level": NSNull(),
            "class_mode": NSNull()
        ]
        
        self.showActivityIndicator()
        APIRequestUtil.shared.registerStudent(parameters: parameters) { response, error in
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                if APIResponseUtil.isValidResponse(viewController: self, response: response, error: error) {
                    self.showAlert(title: AlertConstants.Success, message: "Registration successful. Please verify your emial") {
                        
                        if let navController = self.navigationController {
                            for viewController in navController.viewControllers {
                                if viewController is LoginVC {
                                    navController.popToViewController(viewController, animated: true)
                                    return
                                }
                            }
                        
                            navController.popToRootViewController(animated: true)
                        }
                    }
                } else {
                    self.showAlert(message: "Registration failed. Please try again.")
                }
            }
        }
    }
}
