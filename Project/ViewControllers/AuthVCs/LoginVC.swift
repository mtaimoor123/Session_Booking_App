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
        
        emailTF.text = "cyber truck"
        passwordTF.text = "11223344"
        
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
            
            // Handle any error that occurs during the API call
            if let error = error {
                self.showAlert(title: "Error", message: "\(error.localizedDescription) ->new error")
                return
            }
            
            // Ensure that we received a response from the server
            if let response = response {
                
                if let token = response["token"] as? String {
                    DataManager.shared.saveAccessToken(token: token)
                    print("token Saved Successfully" , token)
                    let vc = self.getRef(storyboard: .Home, identifier: HomeVC.id) as! HomeVC
                    self.pushTo(vc)
                } else if let message = response["message"] as? String, message == "Account not verified" {
                    self.handleUnverifiedAccount(userName: username)
                } else {
                    self.showAlert(title: "Error", message: "No token received or unknown response. Please try again.")
                }
            } else {
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
        pushVC(id: ForgetPasswordVC.id)
    }
    
    @IBAction func registerNowVC(_ sender: Any) {
        print(#function)
        pushVC(id: NameVC.id)
    }
}
