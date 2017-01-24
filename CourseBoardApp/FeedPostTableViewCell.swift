//
//  FeedPostTableViewCell.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/7/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class FeedPostTableViewCell: UITableViewCell {

    // Variables
    var post: Post! {
        didSet {
            
            profilePictureImageView.image = post.user?.profilePic
            nameLabel.text = post.user?.fullname
            usernameLabel.text = post.user?.username
            courseLabel.text = post.course?.title
            //cell.dateLabel.text = post.date
            setupLineSpacing(string: post.body ?? "") // set description label
            
        }
    }
    
    // UI Elements
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            setupLineSpacing(string: descriptionLabel.text ?? "")
        }
    }
    
    // Table View Cell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set up Profile Picture
        profilePictureImageView.layer.borderWidth = 0.5
        profilePictureImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Line Spacing
        setupLineSpacing(string: "")
    }
    
    func setupLineSpacing(string: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        descriptionLabel.attributedText = attrString
    }

}
