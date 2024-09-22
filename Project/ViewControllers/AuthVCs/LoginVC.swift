//
//  LoginVC.swift
//  Project
//
//  Created by Muaaz on 27/07/2024.
//

import UIKit

class LoginVC: BaseClass {
    
    @IBOutlet weak var rememberMeBtnOutlet: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    var isRemembered = false
    var isUserVerified = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.setLeftPaddingPoints(20)
        passwordTF.setLeftPaddingPoints(20)
        rememberMeBtnOutlet.setImage(UIImage(systemName: "circle"), for: .normal)
        
        emailTF.text = "test12345"
        passwordTF.text = "12345678"
        
    }
    
    @IBAction func showPaswrod(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTF.isSecureTextEntry = !sender.isSelected
        sender.setImage(UIImage(systemName: sender.isSelected ? "eye.slash" : "eye"), for: .normal)
    }
    
    @IBAction func remeberMePressed(_ sender: UIButton) {
        isRemembered.toggle()
        sender.setImage(UIImage(systemName: isRemembered ? "checkmark.circle.fill" : "circle"), for: .normal)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard let username = emailTF.text, let password = passwordTF.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter valid username and password")
            return
        }
        
        showActivityIndicator()
        APIRequestUtil.shared.loginStudent(parameters: ["username": username, "password": password]) { response, error in
            self.hideActivityIndicator()
            
            if let error = error {
                self.showAlert(title: "Error", message:"\( error.localizedDescription) ->new error")
                return
            }
            
            if let response = response, let success = response["success"] as? Int {
                
                if success == 0, let message = response["message"] as? String {
                    // If the account is not verified, run a specific method
                    if message == "Account not verified" {
                        self.handleUnverifiedAccount(userName: username) // Call your custom method here
                    } else {
                        self.showAlert(title: "Error", message: message)
                    }
                } else if success == 1 {
                    // Success case, proceed with decoding the student
                    if let student: Student = Student.fromDictionary(response) {
                        print("Student decoded successfully: \(student)")
                        let vc = self.getRef(storyboard: .Main, identifier: HomeVC.id) as! HomeVC
                        self.pushTo(vc)
                    } else {
                        print("Failed to decode Student.")
                        self.showAlert(title: "Error", message: "Unable to login. Please try again.")
                    }
                } else {
                    // Handle any other case, like unknown error
                    self.showAlert(title: "Error", message: "An unknown error occurred. Please try again.")
                }
            } else {
                //show alert for invalid response
                self.showAlert(title: "Error", message: "Invalid response from server.")
            }
        }
    }
    
    func handleUnverifiedAccount(userName: String) {
        print("Handling unverified account")
        self.showAlert(title: "Account not verified", message: "Please verify your account by checking your email.") {
            let nextVC = self.getRef(identifier: PinVC.id) as! PinVC
            nextVC.username = userName
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func forgetPressed(_ sender: Any) {
        print(#function)
        pushVC(storyboard: .Home, id: HomeVC.id)
    }
    
    @IBAction func registerNowVC(_ sender: Any) {
        print(#function)
        pushVC(id: NameVC.id)
    }
}
