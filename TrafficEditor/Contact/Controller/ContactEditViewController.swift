//
//  ContactEditViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/25/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

class ContactEditViewController: UIViewController {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfbirthTextField: UITextField!
    @IBOutlet weak var experienceTextField: UITextField!
    @IBOutlet weak var driverIdTextField: UITextField!
    @IBOutlet weak var carModelTextField: UITextField!
    @IBOutlet weak var carryingTextField: UITextField!
    @IBOutlet weak var carNumberTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    let coreDataMethods = ContactCoreDataMethods()
    var contactViewModel: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        firstNameTextField.text = contactViewModel?.firstName
        lastNameTextField.text = contactViewModel?.lastName
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        contactViewModel?.firstName = firstNameTextField.text
        contactViewModel?.lastName = lastNameTextField.text
        coreDataMethods.saveContact()
    }
}
