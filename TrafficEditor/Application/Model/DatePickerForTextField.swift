//
//  DatePickerForTextField.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 12/1/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

class DatePickerForTextField {
    private let datePicker = UIDatePicker()
    private var dateTextField = UITextField()
    
    init(dateTextField: UITextField, view: UIView) {
        self.dateTextField = dateTextField
    }
    
    func createDatePicker() {
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //barButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        //assign toolbar
        dateTextField.inputAccessoryView = toolbar
        
        dateTextField.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc func donePressed(_ view: UIView) {
        // date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
}


