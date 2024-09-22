//
//  BookSessionVC.swift
//  Project
//
//  Created by M Taimoor on 22/09/2024.
//

import UIKit
import Alamofire

class BookSessionVC: BaseClass {
    
    @IBOutlet weak var timeINTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeForSessionTF: UITextField!
    @IBOutlet weak var courseTF: UITextField!
    @IBOutlet weak var topicTF: UITextField!
    @IBOutlet weak var notesTF: UITextField!
    @IBOutlet weak var timeOUTTF: UITextField!
    @IBOutlet weak var bookSessionOnline: UIButton!
    
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    var isSessionBookedOnline = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        timeINTF.setLeftPaddingPoints(15)
        dateTF.setLeftPaddingPoints(15)
        timeForSessionTF.setLeftPaddingPoints(15)
        courseTF.setLeftPaddingPoints(15)
        topicTF.setLeftPaddingPoints(15)
        notesTF.setLeftPaddingPoints(15)
        timeOUTTF.setLeftPaddingPoints(15)
        setupDatePicker()
        setupTimePickers()
        bookSessionOnline.setTitle("  Need a session Online?", for: .normal)
        bookSessionOnline.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        //        datePicker.minimumDate = Date()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePickingDate))
        toolbar.setItems([doneButton], animated: true)
        dateTF.inputView = datePicker
        dateTF.inputAccessoryView = toolbar
    }
    
    @objc func donePickingDate() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        dateTF.text = formatter.string(from: datePicker.date)
        dateTF.resignFirstResponder()
    }
    
    func setupTimePickers() {
        timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePickingTime))
        toolbar.setItems([doneButton], animated: true)
        timeINTF.inputView = timePicker
        timeINTF.inputAccessoryView = toolbar
        
        timeOUTTF.inputView = timePicker
        timeOUTTF.inputAccessoryView = toolbar
    }
    
    @objc func donePickingTime() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        if timeINTF.isFirstResponder {
            timeINTF.text = formatter.string(from: timePicker.date)
            timeINTF.resignFirstResponder()
        } else if timeOUTTF.isFirstResponder {
            if let startTime = timeINTF.text, !startTime.isEmpty {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "h:mm a"
                if let startDate = timeFormatter.date(from: startTime) {
                    //  timePicker.minimumDate = startDate
                }
            } else {
                //  timePicker.minimumDate = Date()
            }
            timeOUTTF.text = formatter.string(from: timePicker.date)
            timeOUTTF.resignFirstResponder()
        }
        calculateSessionDuration()
    }
    
    func calculateSessionDuration() {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // Adjust format to match the time picker output
        
        if let startTime = formatter.date(from: timeINTF.text ?? ""), let endTime = formatter.date(from: timeOUTTF.text ?? "") {
            let duration = Calendar.current.dateComponents([.minute], from: startTime, to: endTime)
            if let totalMinutes = duration.minute {
                timeForSessionTF.text = "\(totalMinutes) minutes"
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        goBack()
        //      print(timeINTF.text , timeOUTTF.text , timeForSessionTF.text)
    }
    
    @IBAction func bookSessionOnlinePressed(_ sender: UIButton) {
        UIView.transition(with: bookSessionOnline, duration: 0.3, options: .transitionFlipFromTop, animations: {
            if !self.isSessionBookedOnline {
                self.bookSessionOnline.setTitle("  Session Booked Online.", for: .normal)
                self.bookSessionOnline.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                self.isSessionBookedOnline = true
            } else {
                self.bookSessionOnline.setTitle("  Need a session Online?", for: .normal)
                self.bookSessionOnline.setImage(UIImage(systemName:"circle"), for: .normal)
                self.isSessionBookedOnline = false
            }
        } , completion: nil)
        
        print(isSessionBookedOnline)
    }
    
    @IBAction func BookSessionPressed(_ sender: Any) {
        guard let dateOfBooking = dateTF.text, !dateOfBooking.isEmpty,
              let timeIn = timeINTF.text, !timeIn.isEmpty,
              let timeOut = timeOUTTF.text, !timeOut.isEmpty,
              let sessionBooked = timeForSessionTF.text, !sessionBooked.isEmpty,
              let course = courseTF.text, !course.isEmpty,
              let topic = topicTF.text, !topic.isEmpty,
              let notes = notesTF.text else {
            showAlert(title: AlertConstants.Error, message: AlertConstants.AllFieldNotFilled)
            return
        }
        
        // Create parameters dictionary
        let parameters: [String: Any] = [
            "dateOfBooking": dateOfBooking,
            "timeIn": timeIn,
            "timeOut": timeOut,
            "sessionBooked": sessionBooked,
            "course": course,
            "topic": topic,
            "notes": notes,
            "isOnline": isSessionBookedOnline
        ]
        
        // Make API call
        APIRequestUtil.shared.bookSession(parameters: parameters) { response, error in
            if let error = error {
                
                self.showAlert(title: AlertConstants.Error, message: error.localizedDescription)
            } else if let responseDict = response, let errorMessage = responseDict["error"] as? String {
                let token = DataManager.shared.getAccessToken()
                print(token)
                // Handle API response that contains an error message
                self.showAlert(title: AlertConstants.Error, message: errorMessage)
            } else {
                
                self.showAlert(title: AlertConstants.Success, message: "Session booked successfully!") {
                    
                    self.timeINTF.text = ""
                    self.dateTF.text = ""
                    self.timeForSessionTF.text = ""
                    self.courseTF.text = ""
                    self.topicTF.text = ""
                    self.notesTF.text = ""
                    self.timeOUTTF.text = ""
                    
                    self.isSessionBookedOnline = false
                    self.bookSessionOnline.setTitle("  Book Session Online", for: .normal)
                    self.bookSessionOnline.setImage(UIImage(systemName: "circle"), for: .normal)
                    self.goBack()
                    
                }
            }
        }
    }
}
