//
//  CargoCreateViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/5/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

class CargoCreateViewController: UIViewController {
    
    @IBOutlet weak var cargoImage: UIImageView!
    @IBOutlet weak var cargoNameTextField: UITextField!
    @IBOutlet weak var cargoTypeTextField: UITextField!
    @IBOutlet weak var invoiceNumberTextField: UITextField!
    @IBOutlet weak var cargoWeightTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    let coreDataMethods = CargoCoreDataMethods()
    var refactoringCargo = RefactoringCargoDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        hideKeyboardByTap()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let error = validateFields()
        
        if error != nil {
            showInfo(error!, color: .red)
        } else {
            let newCargo = Cargo(context: self.coreDataMethods.context)
            newCargo.cargoName = cargoNameTextField.text!
            newCargo.cargoType = cargoTypeTextField.text!
            newCargo.invoiceNumber = invoiceNumberTextField.text!
            newCargo.cargoWeight = cargoWeightTextField.text!
            newCargo.cargoImage = refactoringCargo.imageForSave?.pngData()
            self.coreDataMethods.cargoArray.append(newCargo)
            self.coreDataMethods.saveCargo()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        
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
extension CargoCreateViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
extension CargoCreateViewController {
    func validateFields() -> String? {
        // Check that all fields are filled in
        if cargoNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            cargoTypeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            invoiceNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            cargoWeightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        return nil
    }
}

//MARK: - Castomization
extension CargoCreateViewController {
    func setUpElements() {
        
        infoLabel.alpha = 0
        
        cargoImage.layer.cornerRadius = 50
        
        //Style the elements
        Utilities.styleTextField(cargoNameTextField)
        Utilities.styleTextField(cargoTypeTextField)
        Utilities.styleTextField(invoiceNumberTextField)
        Utilities.styleTextField(cargoWeightTextField)
        Utilities.styleFilledButton(saveButton)
    }
    
    func showInfo(_ text: String, color: UIColor) {
        infoLabel.text = text
        infoLabel.textColor = color
        infoLabel.alpha = 1
    }
}
