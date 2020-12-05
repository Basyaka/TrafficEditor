//
//  DatePickerLogicForRoute.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 12/2/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

//Extensions for Route View Contollers logic about Date Picker embedding in Text Fields

//MARK: - Create
extension RouteCreateViewController {
    func createDatePickerForUploadDateTextField() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //barButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedForUploadDate))
        toolbar.setItems([doneButton], animated: true)
        
        //assign toolbar
        uploadDateTextField.inputAccessoryView = toolbar
        
        uploadDateTextField.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc private func donePressedForUploadDate() {
        // date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        refactoringRoute.uploadDateSaveString = formatter.string(from: datePicker.date)
        uploadDateTextField.text = refactoringRoute.uploadDateViewString + refactoringRoute.uploadDateSaveString!
        view.endEditing(true)
    }
    
    func createDatePickerForUnloadDateTextField() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //barButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedForUnloadDate))
        toolbar.setItems([doneButton], animated: true)
        
        //assign toolbar
        unloadDateTextField.inputAccessoryView = toolbar
        
        unloadDateTextField.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc private func donePressedForUnloadDate() {
        // date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        refactoringRoute.unloadDateSaveString = formatter.string(from: datePicker.date)
        unloadDateTextField.text = refactoringRoute.unloadDateViewString + refactoringRoute.unloadDateSaveString!
        view.endEditing(true)
    }
}

//MARK: - View And Edit
extension RouteViewAndEditViewController {
    func createDatePickerForUploadDateTextField() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //barButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedForUploadDate))
        toolbar.setItems([doneButton], animated: true)
        
        //assign toolbar
        uploadDateTextField.inputAccessoryView = toolbar
        
        uploadDateTextField.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc private func donePressedForUploadDate() {
        // date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        refactoringRoute.uploadDateSaveString = formatter.string(from: datePicker.date)
        uploadDateTextField.text = refactoringRoute.uploadDateViewString + refactoringRoute.uploadDateSaveString!
        view.endEditing(true)
    }
    
    func createDatePickerForUnloadDateTextField() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //barButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedForUnloadDate))
        toolbar.setItems([doneButton], animated: true)
        
        //assign toolbar
        unloadDateTextField.inputAccessoryView = toolbar
        
        unloadDateTextField.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc private func donePressedForUnloadDate() {
        // date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        refactoringRoute.unloadDateSaveString = formatter.string(from: datePicker.date)
        unloadDateTextField.text = refactoringRoute.unloadDateViewString + refactoringRoute.unloadDateSaveString!
        view.endEditing(true)
    }
}
