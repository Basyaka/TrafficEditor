//
//  LoginAndRegistrationViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 9/23/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit
import CoreData

class LoginAndRegistrationViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        dissmissKeyboard()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        let error = validateFieldsForLogin()
        
        if error != nil {
            showInfo(error!, color: .red)
        } else {
            // Create cleaned versions of the data
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Login logic
            let predicateUsername = NSPredicate(format: "username LIKE %@", username)
            let predicatePassword = NSPredicate(format: "password LIKE %@", password)
            
            if fetchRequestUsers(predicate: predicateUsername) == true && fetchRequestUsers(predicate: predicatePassword) == true {
                moveToMainVC()
            } else {
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
            
            //Create new user
            let newUser = Users(context: context)
            newUser.username = username
            newUser.password = password
            
            //Save
            saveDataUsers()
        }
    }
    
    //MARK: - CoreData methods
    
    func saveDataUsers() {
        do {
            try context.save()
            showInfo("User created", color: .green)
        } catch {
            showInfo(error.localizedDescription, color: .red)
        }
    }
    
    func fetchRequestUsers(predicate: NSPredicate) -> Bool {
        var storage: [Users]?
        
        do {
            let request = Users.fetchRequest() as NSFetchRequest<Users>
            request.predicate = predicate
            storage = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        if storage != [] {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - Move VC Logic
    
    func moveToMainVC() {
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: K.Storyboard.mainViewContoller) as? MainViewController
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }
    
    //MARK: - Validate Text Fields
    
    func validateFieldsForLogin() -> String? {
        // Check that all fields are filled in
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        return nil
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFieldsForRegistration() -> String? {
        // Check that all fields are filled in
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if PasswordParameters.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        return nil
    }
    
    //MARK: - Castomization
    
    func setUpElements() {
        
        // Hide the info label
        infoLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(registrationButton)
    }
    
    func showInfo(_ text: String, color: UIColor) {
        infoLabel.text = text
        infoLabel.textColor = color
        infoLabel.alpha = 1
    }
}

//MARK: - Dissmiss keyboard
extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dissmissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}

