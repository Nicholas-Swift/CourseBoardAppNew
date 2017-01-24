//
//  CourseObjectiveTableViewCell.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/9/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class CourseObjectiveTableViewCell: UITableViewCell {

    // Variables
    var desc: String! {
        didSet {
            setupLineSpacing(string: desc)
        }
    }
    
    // UI Elements
    
    @IBOutlet weak var informationLabel: UILabel!
    
    // Table View Cell
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupLineSpacing(string: String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        informationLabel.attributedText = attrString
        
    }
}
