//
//  CourseParticipantTableViewCell.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/9/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class CourseParticipantTableViewCell: UITableViewCell {

    var user: User! {
        didSet {
            nameLabel.text = user.fullname ?? ""
            usernameLabel.text = user.username ?? ""
            profilePictureImageView.image = user.profilePic
        }
    }
    
    // UI Elements
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // Table View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set up Profile Picture
        profilePictureImageView.layer.borderWidth = 0.5
        profilePictureImageView.layer.borderColor = UIColor.lightGray.cgColor
        profilePictureImageView.clipsToBounds = true
    }

}
