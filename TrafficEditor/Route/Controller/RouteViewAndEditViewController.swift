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
    
    let sharedRoute = RouteCoreDataMethods.shared
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
            infoLabel.alpha = 0
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
            }
        }
    }
}

//MARK: - Methods For Load And Update Data
extension RouteViewAndEditViewController {
    func loadTransmittedRouteInformation() {
        //Transfered data
        pointATextField.text = sharedRoute.routeModel?.pointA
        pointBTextField.text = sharedRoute.routeModel?.pointB
        routeNumberTextField.text = sharedRoute.routeModel?.routeNumber
        
        if let date = RouteCoreDataMethods.shared.routeModel?.uploadDate {
            uploadDateTextField.text = refactoringRoute.uploadDateViewString + datePickerConvertMethods.dateToString(date)
        }
        
        if let date = RouteCoreDataMethods.shared.routeModel?.unloadDate {
            unloadDateTextField.text = refactoringRoute.unloadDateViewString + datePickerConvertMethods.dateToString(date)
        }
        
        if let distanceString = sharedRoute.routeModel?.distanceRoute {
            distanceTextField.text = distanceString
        }
    }
    
    func updateRouteInformation() {
        
        // Create cleaned versions of the data
        let pointA = pointATextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pointB = pointBTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let routeNumber = routeNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Check routeNumber for uniqueness
        if routeNumber != sharedRoute.routeModel?.routeNumber &&
            sharedRoute.checkingFetchRequest(format: "routeNumber LIKE %@", argument: routeNumber) == true {
            view.endEditing(true)
            showInfo("This route number exists. Please сheck if the input is correct.", color: .red)
        } else {
            
            //update item
            sharedRoute.routeModel?.pointA = pointA
            sharedRoute.routeModel?.pointB = pointB
            sharedRoute.routeModel?.distanceRoute = distanceTextField.text
            sharedRoute.routeModel?.routeNumber = routeNumber
            
            if refactoringRoute.uploadDateSaveString != nil {
                sharedRoute.routeModel?.uploadDate = datePickerConvertMethods.stringToDate(refactoringRoute.uploadDateSaveString!)
            }
            
            if refactoringRoute.unloadDateSaveString != nil {
                sharedRoute.routeModel?.unloadDate = datePickerConvertMethods.stringToDate(refactoringRoute.unloadDateSaveString!)
            }
            
            sharedRoute.saveRoute()
            contentView.backgroundColor = .systemBackground
            showInfo("Successful data update.", color: .green)
        }
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

//MARK: - Notification for keyboard
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
