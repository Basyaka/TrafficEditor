//
//  RouteEditViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/5/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

class RouteCreateViewController: UIViewController {
    
    @IBOutlet weak var pointATextField: UITextField!
    @IBOutlet weak var pointBTextField: UITextField!
    @IBOutlet weak var uploadDateTextField: UITextField!
    @IBOutlet weak var unloadDateTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var routeNumberTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    let datePicker = UIDatePicker()
    
    let coreDataMethods = RouteCoreDataMethods()
    let datePickerConvertMethods = DatePickerConvertMethods()
    var refactoringRoute = RefactoringRouteDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePickerForUploadDateTextField()
        createDatePickerForUnloadDateTextField()
        setUpElements()
        hideKeyboardByTap()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let error = validateFields()
        
        if error != nil {
            showInfo(error!, color: .red)
        } else {
            let newRoute = Route(context: coreDataMethods.context)
            newRoute.pointA = pointATextField.text!
            newRoute.pointB = pointBTextField.text!
            newRoute.uploadDate = datePickerConvertMethods.stringToDate(refactoringRoute.uploadDateSaveString!)
            newRoute.unloadDate = datePickerConvertMethods.stringToDate(refactoringRoute.unloadDateSaveString!)
            newRoute.distanceRoute = distanceTextField.text!
            newRoute.routeNumber = routeNumberTextField.text!
            self.coreDataMethods.routeArray.append(newRoute)
            self.coreDataMethods.saveRoute()
            self.navigationController?.popToRootViewController(animated: true)
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
