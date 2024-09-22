//
//  EmailVC.swift
//  Project
//
//  Created by Muaaz on 09/08/2024.
//
import UIKit

class EmailVC: BaseClass {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var confirmEmailTF: UITextField!
    @IBOutlet weak var secondaryEmailTF: UITextField!
    @IBOutlet weak var alertLbl: UILabel!
    
    var userSignup: UserSignup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertLbl.isHidden = true
        emailTF.setLeftPaddingPoints(20)
        confirmEmailTF.setLeftPaddingPoints(20)
        secondaryEmailTF.setLeftPaddingPoints(20)
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        // Validate the input
        guard let email = emailTF.text, !email.isEmpty
             // let confirmEmail = confirmEmailTF.text, email == confirmEmail
        else {
            alertLbl.isHidden = false
            alertLbl.text = "Please fill all fields and make sure the emails match"
            return
        }
        
        userSignup.email = email
     //   userSignup.secondaryEmail = secondaryEmailTF.text
        let passwordVC = storyboard?.instantiateViewController(withIdentifier: "PasswordVC") as! PasswordVC
        passwordVC.userSignup = userSignup
        navigationController?.pushViewController(passwordVC, animated: true)
    }
}
