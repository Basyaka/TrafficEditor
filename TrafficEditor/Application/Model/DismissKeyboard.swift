//
//  DismissKeyboard.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/30/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func hideKeyboardByTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}
