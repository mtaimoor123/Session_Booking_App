//
//  NewDailerVC.swift
//  DailerScreen
//
//  Created by M Taimoor on 19/05/2024.
//

import UIKit

class PinVC: BaseClass {
    
    @IBOutlet var allButtons: [UIButton]!
    @IBOutlet var checkImg: [UIImageView]!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var deleteOutlet: UIButton!
    
    var currentTFIndex = 0
    var currentImgIndex = 0
    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("=========",username,"========")
        setupUI()
    }
    
    @IBAction func goBack(_ sender: Any) {
        goBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View Will Appear")
        sendOTPCode(username: username)
    }
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        print("Number button pressed: \(sender.accessibilityIdentifier!)")
        if let digit = sender.accessibilityIdentifier, let digitInt = Int(digit) {
            if currentTFIndex < textFields.count && currentImgIndex < checkImg.count {
                let textField = textFields[currentTFIndex]
                textField.text = "\(digitInt)"
                checkImg[currentImgIndex].image = UIImage(named: "DotFilled")
                
                currentTFIndex += 1
                currentImgIndex += 1
                
                if currentTFIndex == textFields.count {
                    // All text fields are filled, check the PIN
                    checkPIN()
                } else {
                    // Focus on the next text field
                    let nextTextField = textFields[currentTFIndex]
                    nextTextField.isUserInteractionEnabled = true
                    nextTextField.becomeFirstResponder()
                    view.endEditing(true)
                    nextTextField.inputView = UIView()
                }
            }
        }
    }
    
    @IBAction func crossButtonPressed(_ sender: UIButton) {
        if sender.title(for: .normal) == "Delete" {
            print("Cross button pressed")
            if currentTFIndex > 0 {
                currentTFIndex -= 1
                currentImgIndex -= 1
                
                let textField = textFields[currentTFIndex]
                textField.text = ""
                checkImg[currentImgIndex].image = UIImage(named: "DotEmpty")
                textField.isUserInteractionEnabled = true
                textField.becomeFirstResponder()
                view.endEditing(true)
                textField.inputView = UIView()
            }
        } else {
            print("Next button pressed")
        }
    }
}

extension PinVC {
    func sendOTPCode(username: String) {
        APIRequestUtil.shared.sendOTPStudent(parameters: ["username": username]) { response, error in
            if APIResponseUtil.isValidResponse(viewController: self, response: response, error: error) {
                self.hideActivityIndicator()
                self.showAlert(title: AlertConstants.Alert, message: "OTP sent to registered email")
            }
        }
    }
}

extension PinVC : UITextFieldDelegate {
    
    func checkPIN() {
        let enteredPIN = textFields.reduce("") { $0 + ($1.text ?? "") }
        guard enteredPIN.count == textFields.count else {
            print("PIN is incomplete")
            return
        }
        print("Entered PIN: \(enteredPIN)")
        showActivityIndicator()
        APIRequestUtil.shared.verifyOTPStudent(parameters: ["username": username, "otp": enteredPIN]) { response, error in
            self.hideActivityIndicator()
            if APIResponseUtil.isValidResponse(viewController: self, response: response, error: error) {
                if let response = response {
                    print("Full response: \(response)")
                    
                    if let token = response["token"] as? String {
                        print("Here we go for Token: \(token)")
                        UserDefaults.standard.set(token, forKey: "token")
                        
                        // Retrieve and print token to verify it was saved
                        if let savedToken = UserDefaults.standard.string(forKey: "token") {
                            print("Saved Token: \(savedToken)")
                        }
                    } else {
                        print("Token not found in response")
                    }
                } else if let error = error {
                    self.showAlert(message:error.localizedDescription)
                    print("Error occurred: \(error.localizedDescription)")
                }

                // Handle successful OTP verification
                print("OTP verified successfully")
                self.showAlert(title: AlertConstants.Success, message: "OTP verified successfully."){
                    self.pushVC(storyboard: .Home, id: HomeVC.id)
                }
            } else {
                // Handle invalid OTP or errors
                self.showAlert(title: "Error", message: "Invalid OTP or Error occurred.")
                print("Invalid OTP or Error occurred.")
            }
        }
    }
}
// TextField and UI Setup
extension PinVC {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count ?? 0) + string.count - range.length
        if newLength == 1 {
            // Move to the next text field if the current one is filled
            if let currentIndex = textFields.firstIndex(of: textField), currentIndex < textFields.count - 1 {
                textFields[currentIndex].isUserInteractionEnabled = false
                textFields[currentIndex + 1].isUserInteractionEnabled = true
                textFields[currentIndex + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder() // Last field, dismiss keyboard
            }
            return true
        } else if newLength == 0 {
            // Handle deletion and go back to the previous field
            if let currentIndex = textFields.firstIndex(of: textField), currentIndex > 0 {
                textFields[currentIndex].isUserInteractionEnabled = false
                textFields[currentIndex - 1].isUserInteractionEnabled = true
                textFields[currentIndex - 1].becomeFirstResponder()
            }
        }
        return newLength <= 1
    }
    
    func setupUI() {
        for button in allButtons {
            button.layer.cornerRadius = button.frame.height / 2
            button.layer.borderColor = UIColor.black.cgColor
            
        }
        for textfield in textFields {
            textfield.isUserInteractionEnabled = false
            textfield.delegate = self
            view.endEditing(true)
            textfield.inputView = UIView()
        }
        // Enable the first text field
        if !textFields.isEmpty {
            textFields[0].isUserInteractionEnabled = true
            textFields[0].becomeFirstResponder()
        }
    }
}
