//
//  LoginViewController.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 1/25/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Instance Vars
    
    // MARK: - UI Elements
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - UI Actions
    @IBAction func loginAction(_ sender: Any) {
        login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldSetup()
        loginButtonSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        usernameTextField.becomeFirstResponder()
    }
    
}

// MARK: - Setup
extension LoginViewController {
    
    func textFieldSetup() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func loginButtonSetup() {
        loginButton.layer.cornerRadius = 5
    }
    
}

// MARK: - Functionality
extension LoginViewController {
    
    func login(username: String, password: String) {
        
        // Login to course board through api
        CourseBoardAPI.login(email: username, password: password) { [weak self] (bool: Bool, error: NSError?) in
            
            // Error occured
            if let _ = error {
                
                // Present alert
                self?.displayAlert(title: "Error occured", message: "An error occured when trying to log in")
                
                // Remove text
                self?.passwordTextField.text = ""
                
                return
            }
            
            // Incorrect password
            if bool == false {
                
                // Present alert
                self?.displayAlert(title: "Incorrect username or password", message: "")
                
                // Remove text
                self?.passwordTextField.text = ""
                
                return
            }
            
            // Successful log in!
            self?.loginSuccess()
            
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func loginSuccess() {
        performSegue(withIdentifier: "LoggedInSegue", sender: nil)
    }
    
}

// MARK: - Text Field
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Go to password
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        // Log in
        if textField == passwordTextField {
            login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
        }
        
        return true
    }
    
}
