//
//  DatePickerLogicExtensionsForContact.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 12/1/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

//Extensions for Contact View Contollers logic about Date Picker embedding in Text Fields

//MARK: - Create
extension ContactCreateViewController {
    func createDatePickerForDateOfBirthTextField() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //barButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedForDateOfBirth))
        toolbar.setItems([doneButton], animated: true)
        
        //assign toolbar
        dateOfbirthTextField.inputAccessoryView = toolbar
        
        dateOfbirthTextField.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc private func donePressedForDateOfBirth() {
        // date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateOfbirthTextField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    func reateDatePickerForExperienceTextField() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //barButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedForExperience))
        toolbar.setItems([doneButton], animated: true)
        
        //assign toolbar
        experienceTextField.inputAccessoryView = toolbar
        
        experienceTextField.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc private func donePressedForExperience() {
        // date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        refactoringContact.experienceSaveString = formatter.string(from: datePicker.date)
        experienceTextField.text = refactoringContact.experienceViewString + refactoringContact.experienceSaveString!
        view.endEditing(true)
    }
}

//MARK: - View And Edit
extension ContactViewAndEditViewController {
    func createDatePickerForDateOfbirthTextField() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //barButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedForDateOfBirth))
        toolbar.setItems([doneButton], animated: true)
        
        //assign toolbar
        dateOfbirthTextField.inputAccessoryView = toolbar
        
        dateOfbirthTextField.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc private func donePressedForDateOfBirth() {
        // date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateOfbirthTextField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    func createDatePickerForExperienceTextField() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //barButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedForExperience))
        toolbar.setItems([doneButton], animated: true)
        
        //assign toolbar
        experienceTextField.inputAccessoryView = toolbar
        
        experienceTextField.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc private func donePressedForExperience() {
        // date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        refactoringContact.experienceSaveString = formatter.string(from: datePicker.date)
        experienceTextField.text = refactoringContact.experienceViewString + refactoringContact.experienceSaveString!
        view.endEditing(true)
    }
}

