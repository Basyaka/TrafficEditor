//
//  RouteEditViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/5/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

class RouteCreateViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pointATextField: UITextField!
    @IBOutlet weak var pointBTextField: UITextField!
    @IBOutlet weak var uploadDateTextField: UITextField!
    @IBOutlet weak var unloadDateTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var routeNumberTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    let datePicker = UIDatePicker()
    
    let sharedRoute = RouteCoreDataMethods.shared
    let datePickerConvertMethods = DatePickerConvertMethods()
    var refactoringRoute = RefactoringRouteDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePickerForUploadDateTextField()
        createDatePickerForUnloadDateTextField()
        setUpElements()
        hideKeyboardByTap()
        
        registerForKeyboardNotification()
    }
    
    deinit {
        removeKeyboardNotifications()
    }

    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let error = validateFields()
        
        if error != nil {
            showInfo(error!, color: .red)
        } else {
            
            // Create cleaned versions of the data
            let pointA = pointATextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pointB = pointBTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let routeNumber = routeNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Check routeNumber for uniqueness
            if sharedRoute.checkingFetchRequest(format: "routeNumber LIKE %@", argument: routeNumber) == true {
                view.endEditing(true)
                showInfo("This route number exists. Please сheck if the input is correct.", color: .red)
            } else {
                
                let newRoute = Route(context: sharedRoute.context)
                newRoute.pointA = pointA
                newRoute.pointB = pointB
                newRoute.uploadDate = datePickerConvertMethods.stringToDate(refactoringRoute.uploadDateSaveString!)
                newRoute.unloadDate = datePickerConvertMethods.stringToDate(refactoringRoute.unloadDateSaveString!)
                newRoute.distanceRoute = distanceTextField.text!
                newRoute.routeNumber = routeNumber
                newRoute.parentUser = sharedRoute.account
                
                sharedRoute.routeArray.append(newRoute)
                sharedRoute.saveRoute()
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

//MARK: - Validate Text Fields
extension RouteCreateViewController {
    func validateFields() -> String? {
        // Check that all fields are filled in
        if pointATextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            pointBTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            uploadDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            unloadDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            distanceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            routeNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        return nil
    }
}

//MARK: - Castomization
extension RouteCreateViewController {
    func setUpElements() {
        
        infoLabel.alpha = 0
        
        Utilities.styleTextField(pointATextField)
        Utilities.styleTextField(pointBTextField)
        Utilities.styleTextField(uploadDateTextField)
        Utilities.styleTextField(unloadDateTextField)
        Utilities.styleTextField(distanceTextField)
        Utilities.styleTextField(routeNumberTextField)
        Utilities.styleFilledButton(saveButton)
    }
    
    func showInfo(_ text: String, color: UIColor) {
        infoLabel.text = text
        infoLabel.textColor = color
        infoLabel.alpha = 1
    }
}

//MARK: - Notification for keyboard
extension RouteCreateViewController {
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardFrameSize.height)
    }
    
    @objc func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
}
