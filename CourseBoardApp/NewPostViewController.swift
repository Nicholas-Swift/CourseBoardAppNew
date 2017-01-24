//
//  NewPostViewController.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 12/19/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {
    
    // Variables
    
    // UI Elements
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var courseButton: UIButton!
    
    // UI Actions
    @IBAction func cancelBarAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup style
        styleSetup()
        
        postTextView.text = ""
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
}

extension NewPostViewController {
    func styleSetup() {
        // Set up Nav Bar style
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(ColorHelper.redditLightGrayColor)
        self.navigationController?.navigationBar.isTranslucent = false
    }
}
