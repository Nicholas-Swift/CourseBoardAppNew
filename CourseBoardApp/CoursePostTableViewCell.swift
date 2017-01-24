//
//  CoursePostTableViewCell.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/9/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class CoursePostTableViewCell: UITableViewCell {

    // Variables
    var body: String! {
        didSet {
            setupLineSpacing(string: body)
        }
    }
    
    // UI Elements
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    // Table View Cell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set up Profile Picture
        profilePictureImageView.layer.borderWidth = 0.5
        profilePictureImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupLineSpacing(string: String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        bodyLabel.attributedText = attrString
        
    }

}
