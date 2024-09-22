//
//  BaseClass.swift
//  MehandiApp
//
//  Created by Muaaz on 11/12/2023.
//

import UIKit
class BaseClass: UIViewController{
    
    private var activityIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
        
    func showActivityIndicator(style: UIActivityIndicatorView.Style = .large, color: UIColor = .gray) {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: style)
            activityIndicator?.color = color
            activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(activityIndicator!)
            
            NSLayoutConstraint.activate([
                activityIndicator!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator!.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
        activityIndicator?.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
    }
//    func pushVC(vc : String , sb : AppStoryboard = .Main) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: sb.rawValue, bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: vc)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    func goBack() {
//        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
//    }
    
    func showAlertTwoBtns(title: String = "Alert" , msg: String ,okbtn : String = "OK" , nobtn : String = "Cancel" ) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okbtn, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: nobtn, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}


extension UIViewController {
    // MARK: - ALERTS
    func showSettingsPermissionAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func presentPopover(_ parentViewController: UIViewController, _ viewController: UIViewController, sender: UIView, size: CGSize) {
        viewController.preferredContentSize = size
        viewController.modalPresentationStyle = .popover
        if let pres = viewController.presentationController {
            pres.delegate = parentViewController
        }
        parentViewController.present(viewController, animated: true)
        if let pop = viewController.popoverPresentationController {
            pop.sourceView = sender
            pop.sourceRect = sender.bounds
        }
    }
    
    func showAlert(title: String = AlertConstants.Alert, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .`default`, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, onSuccess closure: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .`default`, handler: { _ in
            closure()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showThreeBtnAlert (title: String, message: String,yesBtn:String,noBtn:String, onSuccess success: @escaping (Bool) -> Void) {
        
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create yes button with action handler
        let yes = UIAlertAction(title: yesBtn, style: .default, handler: { (action) -> Void in
            
            print("Yes button click...")
            success(true)
        })
        
        // Create no button with action handlder
        let no = UIAlertAction(title: noBtn, style: .default) { (action) -> Void in
            print("No button click...")
            success(false)
        }
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button click...")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(yes)
        dialogMessage.addAction(no)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}

extension UIViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
