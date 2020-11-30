//
//  CargoViewViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/5/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

class CargoViewAndEditViewController: UIViewController {
    
    @IBOutlet weak var cargoImage: UIImageView!
    @IBOutlet weak var cargoNameTextField: UITextField!
    @IBOutlet weak var cargoTypeTextField: UITextField!
    @IBOutlet weak var uploadDateTextField: UITextField!
    @IBOutlet weak var unloadDateTextField: UITextField!
    @IBOutlet weak var invoiceNumberTextField: UITextField!
    @IBOutlet weak var cargoWeightTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    let coreDataMethods = CargoCoreDataMethods()
    var refactoringCargo = RefactoringCargoDataModel()
    
    private var editBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        dissmissKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Transfered data
        cargoNameTextField.text = coreDataMethods.cargoModel?.cargoName
        cargoTypeTextField.text = coreDataMethods.cargoModel?.cargoType
        
        if let data = coreDataMethods.cargoModel?.cargoImage {
            cargoImage.image = UIImage(data: data)
        } else {
            cargoImage.image = UIImage(systemName: "folder.circle")
        }
        
        isEnabledActiveUIElements(false)
        editButtonSetupForUI()
        
        editBool = true
    }
    
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        switch editBool {
        case true: //edit
            
            isEnabledActiveUIElements(true)
            view.backgroundColor = .systemGray5
            editBarButton.title = "Done"
            
            editBool = false
            
        case false: //done
            let error = validateFields()
            
            if error != nil {
                view.endEditing(true)
                showInfo(error!, color: .red)
            } else {
                editButtonSetupForUI()
                isEnabledActiveUIElements(false)
                
                //update item
                coreDataMethods.cargoModel?.cargoName = cargoNameTextField.text
                coreDataMethods.cargoModel?.cargoType = cargoTypeTextField.text
                
                if refactoringCargo.imageForSave != nil {
                    coreDataMethods.cargoModel?.cargoImage = refactoringCargo.imageForSave?.pngData()
                } else {
                    return
                }
                
                coreDataMethods.saveCargo()
                
                editBool = true

            }
        }
    }
    
    @IBAction func changeImageButtonTapped(_ sender: UIButton) {
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
extension CargoViewAndEditViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            refactoringCargo.imageForSave = editedImage
            cargoImage.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            refactoringCargo.imageForSave = originalImage
            cargoImage.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Validate Text Fields
extension CargoViewAndEditViewController {
    func validateFields() -> String? {
        // Check that all fields are filled in
        if cargoNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            cargoTypeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" //||
        //            dateOfbirthTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        //            experienceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        //            driverIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        //            carModelTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        //            carryingTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        //            carNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        return nil
    }
}

//MARK: - Castomization UI
extension CargoViewAndEditViewController {
    func setUpElements() {
        cargoImage.layer.cornerRadius = 50
        
        Utilities.styleTextField(cargoNameTextField)
        Utilities.styleTextField(cargoTypeTextField)
        Utilities.styleTextField(uploadDateTextField)
        Utilities.styleTextField(unloadDateTextField)
        Utilities.styleTextField(invoiceNumberTextField)
        Utilities.styleTextField(cargoWeightTextField)
    }
    
    func isEnabledActiveUIElements(_ bool: Bool) {
        //Text Field
        cargoNameTextField.isEnabled = bool
        cargoTypeTextField.isEnabled = bool
        uploadDateTextField.isEnabled = bool
        unloadDateTextField.isEnabled = bool
        invoiceNumberTextField.isEnabled = bool
        cargoWeightTextField.isEnabled = bool
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
