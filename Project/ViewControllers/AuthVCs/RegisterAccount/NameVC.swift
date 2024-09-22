import UIKit

class NameVC: BaseClass {

    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var alertLbl: UILabel!
    
    var userSignup = UserSignup()

    override func viewDidLoad() {
        super.viewDidLoad()
        alertLbl.isHidden = true
        lastNameTF.setLeftPaddingPoints(20)
        firstNameTF.setLeftPaddingPoints(20)
        userNameTF.setLeftPaddingPoints(20)
        genderTF.setLeftPaddingPoints(20)
      
        // Add tap gesture to genderTF
        let genderTapGesture = UITapGestureRecognizer(target: self, action: #selector(showGenderActionSheet))
        genderTF.addGestureRecognizer(genderTapGesture)
        genderTF.isUserInteractionEnabled = true
    }
    
    @objc func showGenderActionSheet() {
        let actionSheet = UIAlertController(title: "Select Gender", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Male", style: .default, handler: { _ in
            self.genderTF.text = "Male"
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Female", style: .default, handler: { _ in
            self.genderTF.text = "Female"
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        // Validate the input
        guard let username = userNameTF.text, !username.isEmpty
//              let firstName = firstNameTF.text, !firstName.isEmpty,
//              let lastName = lastNameTF.text, !lastName.isEmpty,
//              let gender = genderTF.text, !gender.isEmpty
        else {
            alertLbl.isHidden = false
            alertLbl.text = "Please fill all fields"
            return
        }

        // Update the userSignup model
        userSignup.username = username
//        userSignup.firstName = firstName
//        userSignup.lastName = lastName
//        userSignup.gender = gender
        let mobileVC = storyboard?.instantiateViewController(withIdentifier: "MobileNoVC") as! MobileNoVC
        mobileVC.userSignup = userSignup
        navigationController?.pushViewController(mobileVC, animated: true)
    }
}
