//
//  ProductCollaboratorTableViewCell.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 1/16/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class ProductCollaboratorTableViewCell: UITableViewCell {
    
    // UI Elements
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    // Table View Cell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set up Profile Picture
        profileImageView.layer.borderWidth = 0.5
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}
