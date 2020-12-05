//
//  RouteViewViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/5/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

class RouteViewAndEditViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pointATextField: UITextField!
    @IBOutlet weak var pointBTextField: UITextField!
    @IBOutlet weak var uploadDateTextField: UITextField!
    @IBOutlet weak var unloadDateTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var routeNumberTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let datePicker = UIDatePicker()
    
    let coreDataMethods = RouteCoreDataMethods()
    let datePickerConvertMethods = DatePickerConvertMethods()
    var refactoringRoute = RefactoringRouteDataModel()
    
    private var editBool = true
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadTransmittedRouteInformation()
        
        isEnabledActiveUIElements(false)
        editButtonSetupForUI()
        
        editBool = true
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        switch editBool {
        case true: //edit
            editBool = false
            
            isEnabledActiveUIElements(true)
            contentView.backgroundColor = .systemGray5
            editButton.title = "Done"
            
        case false: //done
            let error = validateFields()
            
            if error != nil {
                view.endEditing(true)
                showInfo(error!, color: .red)
            } else {
                editBool = true
                
                editButtonSetupForUI()
                isEnabledActiveUIElements(false)
                
                updateRouteInformation()
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

//MARK: - Methods For Load And Update Data
extension RouteViewAndEditViewController {
    func loadTransmittedRouteInformation() {
        //Transfered data
        pointATextField.text = coreDataMethods.routeModel?.pointA
        pointBTextField.text = coreDataMethods.routeModel?.pointB
        routeNumberTextField.text = coreDataMethods.routeModel?.routeNumber
        
        if let date = coreDataMethods.routeModel?.uploadDate {
            uploadDateTextField.text = refactoringRoute.uploadDateViewString + datePickerConvertMethods.dateToString(date)
        }
        
        if let date = coreDataMethods.routeModel?.unloadDate {
            unloadDateTextField.text = refactoringRoute.unloadDateViewString + datePickerConvertMethods.dateToString(date)
        }
        
        if let distanceString = coreDataMethods.routeModel?.distanceRoute {
            distanceTextField.text = distanceString
        }
    }
    
    func updateRouteInformation() {
        //update item
        coreDataMethods.routeModel?.pointA = pointATextField.text
        coreDataMethods.routeModel?.pointB = pointBTextField.text
        coreDataMethods.routeModel?.distanceRoute = distanceTextField.text
        coreDataMethods.routeModel?.routeNumber = routeNumberTextField.text
        
        if refactoringRoute.uploadDateSaveString != nil {
            coreDataMethods.routeModel?.uploadDate = datePickerConvertMethods.stringToDate(refactoringRoute.uploadDateSaveString!)
        } else {
            return
        }
        
        if refactoringRoute.unloadDateSaveString != nil {
            coreDataMethods.routeModel?.unloadDate = datePickerConvertMethods.stringToDate(refactoringRoute.unloadDateSaveString!)
        } else {
            return
        }
        
        coreDataMethods.saveRoute()
    }
}

//MARK: - Validate Text Fields
extension RouteViewAndEditViewController {
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

//MARK: - Castomization UI
extension RouteViewAndEditViewController {
    func setUpElements() {
        Utilities.styleTextField(pointATextField)
        Utilities.styleTextField(pointBTextField)
        Utilities.styleTextField(uploadDateTextField)
        Utilities.styleTextField(unloadDateTextField)
        Utilities.styleTextField(distanceTextField)
        Utilities.styleTextField(routeNumberTextField)
    }
    
    func isEnabledActiveUIElements(_ bool: Bool) {
        //Text Field
        pointATextField.isEnabled = bool
        pointBTextField.isEnabled = bool
        uploadDateTextField.isEnabled = bool
        unloadDateTextField.isEnabled = bool
        distanceTextField.isEnabled = bool
        routeNumberTextField.isEnabled = bool
    }
    
    func editButtonSetupForUI() {
        infoLabel.alpha = 0
        editButton.title = "Edit"
        view.backgroundColor = .systemBackground
    }
    
    func showInfo(_ text: String, color: UIColor) {
        infoLabel.text = text
        infoLabel.textColor = color
        infoLabel.alpha = 1
    }
}

extension RouteViewAndEditViewController {
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
