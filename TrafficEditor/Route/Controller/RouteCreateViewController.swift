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
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var routeNumberTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    let coreDataMethods = RouteCoreDataMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let error = validateFields()
        
        if error != nil {
            showInfo(error!, color: .red)
        } else {
            let newRoute = Route(context: coreDataMethods.context)
            newRoute.pointA = pointATextField.text!
            newRoute.pointB = pointBTextField.text!
            self.coreDataMethods.routeArray.append(newRoute)
            self.coreDataMethods.saveRoute()
            //        performSegue(withIdentifier: K.Segues.RouteVC.fromRouteToEditingRoute, sender: self)
        }
        
    }
}

//MARK: - Validate Text Fields
extension RouteCreateViewController {
    func validateFields() -> String? {
        // Check that all fields are filled in
        if pointATextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            pointBTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
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
