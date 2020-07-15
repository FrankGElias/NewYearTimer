//
//  MainViewController.swift
//  TimeZoneAPI
//
//  Created by Francis Elias on 7/13/20.
//  Copyright © 2020 Frank. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var zipTextField : UITextField!
    @IBOutlet weak var locationLabel : UILabel!
    @IBOutlet weak var timerLabel : UILabel!
    var dataController : DataController? = DataController()
    var object : ZipCodeInfoObject?
    let dcf = DateComponentsFormatter()
    let dateFormater = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNavigationBar()
        settingDelegates()
    }

// MARK: the following function handles the action for our done button and checks in case the input is empty it displays an alert controller

    @IBAction func doneAction() {
        view.endEditing(true)
        let text = zipTextField.text
        if text?.isEmpty ?? true {
            alert(title: "Empty", message: "Please enter a zip code")
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                self.dataController!.fetchZipInfo(text)
            }
        }
    }
    
    func settingNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func settingDelegates() {
        dataController!.delegate = self
    }

    func settingDate() {
        dcf.allowedUnits = [.month, .day, .hour, .minute, .second]
        dcf.unitsStyle = .short
        let timeZone = TimeZone(abbreviation: object!.timezone!.timezone_abbr!)
        dateFormater.dateFormat = "dd:MM:yyy HH:mm:ss"
        dateFormater.timeZone = timeZone
    }

    func alert (title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    @objc func countDownDate() {
        let currentDateString = dateFormater.string(from: Date())
        let currentDate = dateFormater.date(from: currentDateString)
        if let future = dateFormater.date(from: "01:01:2021 00:00:00"), let diff = dcf.string(from: currentDate!, to: future) {
            timerLabel.text = diff
        }
    }
}

extension MainViewController : DataControllerDelegate {
    
// MARK: this function gets called if our json has been parsed successfully, we are yet to check if there is an error in the input or not. in case the error key is nil or not initialized means our response is success.

    func didFinishFetch(_ object : ZipCodeInfoObject) {
        self.object = object
        if object.error_code == nil {
            settingDate()
            DispatchQueue.main.async {
                self.locationLabel.text = "\(object.city ?? "") \(object.state ?? "")"
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(MainViewController.countDownDate), userInfo: nil, repeats: true)
            }
        } else {
            DispatchQueue.main.async {
                self.alert(title: "", message: object.error_msg ?? "Invalid zip code.")
            }
        }
    }

// MARK: gets called in case there was an error in creating our request, or in our parsing.
    
    func didFailFetch(_ error : Error?) {
        if let error = error {
            print("DataController : didFailFetch with error \(error.localizedDescription)")
        } else {
            print("DataController : didFailFetch")
        }
        alert(title: "Error", message: "An error occured, please try again later.")
    }
}
