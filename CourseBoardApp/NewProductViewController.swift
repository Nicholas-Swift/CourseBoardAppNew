//
//  NewProductViewController.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 12/19/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class NewProductViewController: UIViewController {
    
    // Variables
    
    
    // UI Elements
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var problemLabel: UILabel!
    
    @IBOutlet weak var productNameField: UITextField!
    @IBOutlet weak var problemField: UITextField!
    
    
    // UI Actions
    
    @IBAction func cancelBarAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBarAction(_ sender: Any) {
        
        if checkTextFields() == false {
            return // did not fill out all text fields
        }
            
        // Create product
        let product = Product()
        product.name = productNameField.text
        product.problem = problemField.text
        
        CourseBoardAPI.createProduct(product: product, complete: { (bool: Bool?, error: NSError?) in
            if let _ = error {
                self.errorOccured()
                return // error!
            }
            
            guard let _ = bool else {
                self.errorOccured()
                return // error!
            }
            
            print("IT WORKED")
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup style
        styleSetup()
        
        productNameField.text = ""
        problemField.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productNameField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    // Helpers
    
    func checkTextFields() -> Bool {
        
        // Reset default colors
        let defaultColor = UIColor(red: 119/255, green: 118/255, blue: 120/255, alpha: 1)
        productNameLabel.textColor = defaultColor
        problemLabel.textColor = defaultColor
        
        let productNameFieldText = productNameField.text?.replacingOccurrences(of: " ", with: "")
        let problemFieldText = problemField.text?.replacingOccurrences(of: " ", with: "")
        
        // If both have text, continue!
        if productNameFieldText != "" && problemFieldText != "" {
            return true
        }
        
        // Make labels red if not filled
        if productNameFieldText == "" {
            productNameLabel.textColor = UIColor.red
        }
        
        if problemFieldText == "" {
            problemLabel.textColor = UIColor.red
        }
        
        return false
    }
    
    func errorOccured() {
        let alert = UIAlertController(title: "Error", message: "An error occured when trying to create your product", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension NewProductViewController {
    func styleSetup() {
        // Set up Nav Bar style
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(ColorHelper.redditLightGrayColor)
        self.navigationController?.navigationBar.isTranslucent = false
    }
}
