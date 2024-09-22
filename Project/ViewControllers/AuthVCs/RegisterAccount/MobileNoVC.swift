//
//  MobileNoVC.swift
//  Project
//
//  Created by Muaaz on 09/08/2024.
//
import UIKit

class MobileNoVC: BaseClass {
    
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var mobileNoTF: UITextField!
    @IBOutlet weak var confirmMobNoTF: UITextField!
    @IBOutlet weak var secondaryMobNoTF: UITextField!
    @IBOutlet weak var alertLbl: UILabel!
    
    var userSignup: UserSignup!
    let countries = ["United States", "Canada", "United Kingdom", "Australia", "India"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertLbl.isHidden = true
        countryTF.setLeftPaddingPoints(20)
        mobileNoTF.setLeftPaddingPoints(20)
        confirmMobNoTF.setLeftPaddingPoints(20)
        secondaryMobNoTF.setLeftPaddingPoints(20)
        
        // Add tap gesture to countryTF
        let countryTapGesture = UITapGestureRecognizer(target: self, action: #selector(showCountryActionSheet))
        countryTF.addGestureRecognizer(countryTapGesture)
        countryTF.isUserInteractionEnabled = true
    }
    
    @objc func showCountryActionSheet() {
        let actionSheet = UIAlertController(title: "Select Country", message: nil, preferredStyle: .actionSheet)
        
        for country in countries {
            actionSheet.addAction(UIAlertAction(title: country, style: .default, handler: { _ in
                self.countryTF.text = country
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        guard let country = countryTF.text, !country.isEmpty,
              let mobileNo = mobileNoTF.text, !mobileNo.isEmpty
//              let secondaryMobNoTF = secondaryMobNoTF.text 
        else {
            alertLbl.isHidden = false
            alertLbl.text = "Please fill all fields and make sure the phone numbers match"
            return
        }
//        
        // Update the userSignup model
//        userSignup.country = country
//        userSignup.phoneNo = mobileNo
//        userSignup.secondaryPhoneNo = secondaryMobNoTF
//        
        let emailVC = storyboard?.instantiateViewController(withIdentifier: "EmailVC") as! EmailVC
        emailVC.userSignup = userSignup
        navigationController?.pushViewController(emailVC, animated: true)
    }
}
