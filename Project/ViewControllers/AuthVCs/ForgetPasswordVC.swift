//
//  ForgetPasswordVC.swift
//  Project
//
//  Created by M Taimoor on 21/09/2024.
//

import UIKit

class ForgetPasswordVC: BaseClass {
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var confirmNewPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var otpTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTF.setLeftPaddingPoints(20)
        confirmNewPasswordTF.setLeftPaddingPoints(20)
        newPasswordTF.setLeftPaddingPoints(20)
        otpTF.setLeftPaddingPoints(20)
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        newPasswordTF.isSecureTextEntry = !sender.isSelected
        sender.setImage(UIImage(systemName: sender.isSelected ? "eye.slash" : "eye"), for: .normal)
    }
    
    @IBAction func showConfirmPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        confirmNewPasswordTF.isSecureTextEntry = !sender.isSelected
        sender.setImage(UIImage(systemName: sender.isSelected ? "eye.slash" : "eye"), for: .normal)
    }
    
    @IBAction func getOTPButtonPressed(_ sender: Any) {
        sendOTP()
    }
    
    func sendOTP() {
        self.showActivityIndicator()
        guard let username = userNameTF.text, !username.isEmpty,
              let newPassword = newPasswordTF.text, !newPassword.isEmpty,
              let confirmPassword = confirmNewPasswordTF.text, !confirmPassword.isEmpty else {
            self.hideActivityIndicator()
            showAlert(message: "Fields are not filled!")
            return
        }
        guard newPassword.count >= 8 else {
            self.hideActivityIndicator()
            showAlert(message: "Password is too short!")
            return
        }
        guard confirmPassword == newPassword else {
            self.hideActivityIndicator()
            showAlert(message: "Password and Confirm Password do not match!")
            return
        }
        
        APIRequestUtil.shared.sendOTPStudent(parameters: ["username": username]) { response, error in
            if APIResponseUtil.isValidResponse(viewController: self, response: response, error: error) {
                self.hideActivityIndicator()
                self.showAlert(title: "OTP Sent", message: "Enter OTP, Which is sent to your email.")
            }
        }
    }
        
    @IBAction func resetPasswordButtonPressed(_ sender: Any) {
        self.showActivityIndicator()
        guard let username = userNameTF.text, !username.isEmpty,
              let newPassword = newPasswordTF.text, !newPassword.isEmpty,
              let confirmPassword = confirmNewPasswordTF.text, !confirmPassword.isEmpty else {
            self.hideActivityIndicator()
            showAlert(message: "Fields are not filled!")
            return
        }
        guard let otpNumber = otpTF.text, !otpNumber.isEmpty else {
            self.hideActivityIndicator()
            showAlert(message: "OTP is not filled!")
            return
        }
        guard otpNumber.count == 6  else {
            self.hideActivityIndicator()
            showAlert(message: "OTP must be 6 characters long!")
            return
        }
        
        APIRequestUtil.shared.resetPassword(parameters: ["username":  username, "password": newPassword, "confrim_password": confirmPassword, "otp": otpNumber]) { response, error in
            if APIResponseUtil.isValidResponse(viewController: self, response: response, error: error) {
                self.hideActivityIndicator()
                self.showAlert(title: AlertConstants.Success, message: "Password changed successfully!") {
                    self.goBack()
                }
            }
        }
    }
}
