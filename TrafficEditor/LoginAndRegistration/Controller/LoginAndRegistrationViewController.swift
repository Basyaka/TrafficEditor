//
//  LoginAndRegistrationViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 9/23/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

class LoginAndRegistrationViewController: UIViewController {
    
    @IBOutlet weak var passwordStack: UIStackView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var secureTextEntyButton: UIButton!
    
    let sharedUsers = UsersCoreDataMethods.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegates
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        //Start methods
        setUpElements()
        hideKeyboardByTap()
        
        //Test
        usernameTextField.text = "test"
        passwordTextField.text = "Testtest123*"
    }
        
    //MARK: - Buttons logic
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        let error = validateFieldsForLogin()
        
        if error != nil {
            passwordTextField.text? = ""
            showInfo(error!, color: .red)
        } else {
            // Create cleaned versions of the data
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Login logic
            if sharedUsers.fetchRequestUsers(format: "username LIKE %@", argument: username) == true &&
                sharedUsers.fetchRequestUsers(format: "password LIKE %@", argument: password) == true {
                
                //Transfered loginStorage data to relationships
                RouteCoreDataMethods.shared.account = sharedUsers.loginStorage?.first
                ContactCoreDataMethods.shared.account = sharedUsers.loginStorage?.first
                CargoCoreDataMethods.shared.account = sharedUsers.loginStorage?.first
                
                performSegue(withIdentifier: K.Segues.toMainViewController, sender: nil)
                
            } else {
                passwordTextField.text? = ""
                showInfo("Incorrect username or password.", color: .red)
            }
        }
    }
    
    @IBAction func registrationTapped(_ sender: UIButton) {
        
        let error = validateFieldsForRegistration()
        
        if error != nil {
            showInfo(error!, color: .red)
        } else {
            // Create cleaned versions of the data
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Check user for existence
            
            if sharedUsers.fetchRequestUsers(format: "username LIKE %@", argument: username) == true {
                passwordTextField.text? = ""
                showInfo("This username exists. Please select another username.", color: .red)
                
                //Create user logic
            } else {
                
                //Create new user
                let newUser = Users(context: sharedUsers.context)
                newUser.username = username
                newUser.password = password
                
                //Dissmiss keyboard
                view.endEditing(true)
                
                //Save user info
                sharedUsers.saveUsers(label: infoLabel, text: "User created")
            }
        }
    }
    
    //Hiding / Showing text
    @IBAction func secureTextEntyTapped(_ sender: UIButton) {
        if secureTextEntyButton.image(for: UIControl.State.normal) == UIImage(systemName: K.Image.eyeSlash) {
            secureTextEntyButton.setImage(UIImage(systemName: K.Image.eye), for: UIControl.State.normal)
            passwordTextField.isSecureTextEntry = false
        } else {
            secureTextEntyButton.setImage(UIImage(systemName: K.Image.eyeSlash), for: UIControl.State.normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
}

//MARK: - Validate Text Fields
extension LoginAndRegistrationViewController {
    func validateFieldsForLogin() -> String? {
        // Check that all fields are filled in
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        return nil
    }
    
    func validateFieldsForRegistration() -> String? {
        // Check that all fields are filled in
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        // Checking the contents of the username and password
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedUsername = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if ValidateParameters.isPasswordValid(cleanedPassword) == false {
            passwordTextField.text = ""
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        if ValidateParameters.isUsernameValid(cleanedUsername) == false {
            passwordTextField.text = ""
            return "Please make sure your username is at least 4 characters, not contains a special character and a whitespaces."
        }
        
        return nil
    }
}

//MARK: - Castomization
extension LoginAndRegistrationViewController {
    func setUpElements() {
        // Hide the info label
        infoLabel.alpha = 0
        
        passwordTextField.borderStyle = .none
        
        
        // Style the elements
        Utilities.styleTextField(usernameTextField)
        Utilities.styleForStack(passwordStack)
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(registrationButton)
        
        Utilities.parametersPlaceholder(textField: usernameTextField, textPlaceholder: "Username", color: .gray)
        Utilities.parametersPlaceholder(textField: passwordTextField, textPlaceholder: "Password", color: .gray)
    }
    
    func showInfo(_ text: String, color: UIColor) {
        infoLabel.text = text
        infoLabel.textColor = color
        infoLabel.alpha = 1
    }
}
