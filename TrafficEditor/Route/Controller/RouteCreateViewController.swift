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
        let newRoute = Route(context: coreDataMethods.context)
        newRoute.pointA = pointATextField.text!
        newRoute.pointB = pointBTextField.text!
        self.coreDataMethods.routeArray.append(newRoute)
        self.coreDataMethods.saveRoute()
//        performSegue(withIdentifier: K.Segues.RouteVC.fromRouteToEditingRoute, sender: self)
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
}
