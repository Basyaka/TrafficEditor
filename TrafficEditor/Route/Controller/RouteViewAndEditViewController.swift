//
//  RouteViewViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/5/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

class RouteViewAndEditViewController: UIViewController {
    
    @IBOutlet weak var pointATextField: UITextField!
    @IBOutlet weak var pointBTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var routeNumberTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    let coreDataMethods = RouteCoreDataMethods()
    
    private var editBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Transfered data
        pointATextField.text = coreDataMethods.routeModel?.pointA
        pointBTextField.text = coreDataMethods.routeModel?.pointB
        
        isEnabledActiveUIElements(false)
        editButtonSetupForUI()
        
        editBool = true
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        switch editBool {
        case true: //edit
            editBool = false
            
            isEnabledActiveUIElements(true)
            view.backgroundColor = .systemGray5
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
                
                //update item
                coreDataMethods.routeModel?.pointA = pointATextField.text
                coreDataMethods.routeModel?.pointB = pointBTextField.text
                
                coreDataMethods.saveRoute()
            }
        }
    }
}

//MARK: - Validate Text Fields
extension RouteViewAndEditViewController {
    func validateFields() -> String? {
        // Check that all fields are filled in
        if pointATextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            pointBTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" //||
        //            distanceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        //            routeNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
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
        Utilities.styleTextField(distanceTextField)
        Utilities.styleTextField(routeNumberTextField)
    }
     
    func isEnabledActiveUIElements(_ bool: Bool) {
        //Text Field
        pointATextField.isEnabled = bool
        pointBTextField.isEnabled = bool
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
