//
//  SearchUserTableViewCell.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/26/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SearchUserTableViewCell: UITableViewCell {
    
    // Variables
    var user: User! {
        didSet {
            fullnameLabel.text = user.fullname ?? ""
            usernameLabel.text = user.username ?? ""
            profilePictureImageView.image = user.profilePic
        }
    }
    
    // UI Elements
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // Table View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set up Profile Picture
        profilePictureImageView.layer.borderWidth = 0.5
        profilePictureImageView.layer.borderColor = UIColor.lightGray.cgColor
        profilePictureImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        profilePictureImageView.af_cancelImageRequest()
        profilePictureImageView.image = nil
    }
    
}
