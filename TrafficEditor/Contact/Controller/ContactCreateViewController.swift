//
//  ContactCreateViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/5/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit
import CoreData

class ContactCreateViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
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
    
    let datePicker = UIDatePicker()
    
    let sharedContact = ContactCoreDataMethods.shared
    let datePickerConvertMethods = DatePickerConvertMethods()
    var refactoringContact = RefactoringContactDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start methods
        setUpElements()
        createDatePickerForDateOfBirthTextField()
        reateDatePickerForExperienceTextField()
        //        addObservers()
    }
    
    
    //    deinit {
    //        removeObservers()
    //    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                self.infoLabel.text = "Camera not available"
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let error = validateFields()
        
        if error != nil {
            showInfo(error!, color: .red)
        } else {
            
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let driverID = driverIdTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let carNumber = carNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let carModel = carModelTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Check driverID and CarNumber for uniqueness
            if sharedContact.checkingFetchRequest(format: "driverID LIKE %@", argument: driverID) == true {
                view.endEditing(true)
                showInfo("This driver ID exists. Please сheck if the input is correct.", color: .red)
            } else if sharedContact.checkingFetchRequest(format: "carNumber LIKE %@", argument: carNumber) == true {
                view.endEditing(true)
                showInfo("This car number exists. Please сheck if the input is correct.", color: .red)
            } else {
                let newContact = Contact(context: sharedContact.context)
                newContact.firstName = firstName
                newContact.lastName = lastName
                newContact.driverID = driverID
                newContact.carModel = carModel
                newContact.carNumber = carNumber
                newContact.avatarImage = refactoringContact.imageForSave?.pngData()
                newContact.dateOfBirth = datePickerConvertMethods.stringToDate(dateOfbirthTextField.text!)
                newContact.carrying = carryingTextField.text!
                newContact.experience = datePickerConvertMethods.stringToDate(refactoringContact.experienceSaveString!)
                newContact.parentUser = sharedContact.account
                
                sharedContact.contactArray.append(newContact)
                sharedContact.saveContact()
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

//MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ContactCreateViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            refactoringContact.imageForSave = editedImage
            contactImage.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            refactoringContact.imageForSave = originalImage
            contactImage.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Notification for keyboard
extension ContactCreateViewController {
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
}

//MARK: - Validate Text Fields
extension ContactCreateViewController {
    func validateFields() -> String? {
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            dateOfbirthTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            experienceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            driverIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            carModelTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            carryingTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            carNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        return nil
    }
}

//MARK: - Castomization
extension ContactCreateViewController {
    func setUpElements() {
        
        infoLabel.alpha = 0
        
        contactImage.layer.cornerRadius = 50
        
        //Style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(dateOfbirthTextField)
        Utilities.styleTextField(experienceTextField)
        Utilities.styleTextField(driverIdTextField)
        Utilities.styleTextField(carModelTextField)
        Utilities.styleTextField(carryingTextField)
        Utilities.styleTextField(carNumberTextField)
        Utilities.styleFilledButton(saveButton)
    }
    
    func showInfo(_ text: String, color: UIColor) {
        infoLabel.text = text
        infoLabel.textColor = color
        infoLabel.alpha = 1
    }
}
