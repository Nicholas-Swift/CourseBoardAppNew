//
//  ProfileHeaderTableViewCell.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/26/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {
    
    // Variables
    var user: User! {
        didSet {
            self.fullnameLabel.text = user.fullname ?? ""
            self.usernameLabel.text = user.username ?? ""
            self.profilePictureImageView.image = user.profilePic
            self.courseNumber.text = "\(user.enrolledCourses?.count ?? 0)"
            self.productNumber.text = "\(user.products?.count ?? 0)"
        }
    }
    
    // UI Elements
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var courseNumber: UILabel!
    @IBOutlet weak var productNumber: UILabel!
    
    // Table View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set up Profile Picture
        profilePictureImageView.layer.borderWidth = 0.5
        profilePictureImageView.layer.borderColor = UIColor.lightGray.cgColor
        profilePictureImageView.clipsToBounds = true
    }
    
}
