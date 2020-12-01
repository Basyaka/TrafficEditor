//
//  ContactViewViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/5/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

class ContactViewAndEditViewController: UIViewController {
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfbirthTextField: UITextField!
    @IBOutlet weak var experienceTextField: UITextField!
    @IBOutlet weak var driverIdTextField: UITextField!
    @IBOutlet weak var carModelTextField: UITextField!
    @IBOutlet weak var carryingTextField: UITextField!
    @IBOutlet weak var carNumberTextField: UITextField!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var infoLabel: UILabel!
    
    private let datePicker = UIDatePicker()
    
    let coreDataMethods = ContactCoreDataMethods()
    let datePickerConvertMethods = DatePickerConvertMethods()
    var refactoringContact = RefactoringContactDataModel()
    
    private var editBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePickerBirth()
        createDatePickerExperience()
        //Start methods
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Transfered data
        firstNameTextField.text = coreDataMethods.contactModel?.firstName
        lastNameTextField.text = coreDataMethods.contactModel?.lastName
        driverIdTextField.text = coreDataMethods.contactModel?.driverID
        carModelTextField.text = coreDataMethods.contactModel?.carModel
        carryingTextField.text = coreDataMethods.contactModel?.carrying
        carNumberTextField.text = coreDataMethods.contactModel?.carNumber
        
        if let date = coreDataMethods.contactModel?.experience {
            experienceTextField.text = refactoringContact.experienceViewString + datePickerConvertMethods.dateToString(date)
        }
        
        if let date = coreDataMethods.contactModel?.dateOfBirth {
            dateOfbirthTextField.text = datePickerConvertMethods.dateToString(date)
        }
        
        if let data = coreDataMethods.contactModel?.avatarImage {
            contactImage.image = UIImage(data: data)
        } else {
            contactImage.image = UIImage(systemName: "person.circle")
        }
        
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
            editBarButton.title = "Done"
            
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
                coreDataMethods.contactModel?.firstName = firstNameTextField.text
                coreDataMethods.contactModel?.lastName = lastNameTextField.text
                coreDataMethods.contactModel?.driverID = driverIdTextField.text
                coreDataMethods.contactModel?.carModel = carModelTextField.text
                coreDataMethods.contactModel?.carrying = carryingTextField.text
                coreDataMethods.contactModel?.carNumber = carNumberTextField.text
                
                coreDataMethods.contactModel?.dateOfBirth = datePickerConvertMethods.stringToDate(dateOfbirthTextField.text!)
                
                if refactoringContact.experienceSaveString != nil {
                    coreDataMethods.contactModel?.experience = datePickerConvertMethods.stringToDate(refactoringContact.experienceSaveString!)
                } else {
                    return
                }
                
                if refactoringContact.imageForSave != nil {
                    coreDataMethods.contactModel?.avatarImage = refactoringContact.imageForSave?.pngData()
                } else {
                    return
                }
                
                coreDataMethods.saveContact()
                
            }
        }
    }
    
    @IBAction func changeButtonTapped(_ sender: UIButton) {
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
}

//MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ContactViewAndEditViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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

//MARK: - Validate Text Fields
extension ContactViewAndEditViewController {
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

//MARK: - Work with DatePicker
extension ContactViewAndEditViewController {
    func createDatePickerBirth() {
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //barButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedBirth))
        toolbar.setItems([doneButton], animated: true)
        
        //assign toolbar
        dateOfbirthTextField.inputAccessoryView = toolbar
        
        dateOfbirthTextField.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc private func donePressedBirth() {
        // date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateOfbirthTextField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    func createDatePickerExperience() {
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //barButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedExperience))
        toolbar.setItems([doneButton], animated: true)
        
        //assign toolbar
        experienceTextField.inputAccessoryView = toolbar
        
        experienceTextField.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc private func donePressedExperience(_ textField: UITextField) {
        // date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        refactoringContact.experienceSaveString = formatter.string(from: datePicker.date)
        experienceTextField.text = refactoringContact.experienceViewString + refactoringContact.experienceSaveString!
        view.endEditing(true)
    }
}

//MARK: - Castomization UI
extension ContactViewAndEditViewController {
    func setUpElements() {
        contactImage.layer.cornerRadius = 50
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(dateOfbirthTextField)
        Utilities.styleTextField(experienceTextField)
        Utilities.styleTextField(driverIdTextField)
        Utilities.styleTextField(carModelTextField)
        Utilities.styleTextField(carryingTextField)
        Utilities.styleTextField(carNumberTextField)
    }
    
    func isEnabledActiveUIElements(_ bool: Bool) {
        //Text Field
        firstNameTextField.isEnabled = bool
        lastNameTextField.isEnabled = bool
        dateOfbirthTextField.isEnabled = bool
        experienceTextField.isEnabled = bool
        driverIdTextField.isEnabled = bool
        carModelTextField.isEnabled = bool
        carryingTextField.isEnabled = bool
        carNumberTextField.isEnabled = bool
        //Button
        changeImageButton.isEnabled = bool
    }
    
    func editButtonSetupForUI() {
        infoLabel.alpha = 0
        editBarButton.title = "Edit"
        view.backgroundColor = .systemBackground
    }
    
    func showInfo(_ text: String, color: UIColor) {
        infoLabel.text = text
        infoLabel.textColor = color
        infoLabel.alpha = 1
    }
}
