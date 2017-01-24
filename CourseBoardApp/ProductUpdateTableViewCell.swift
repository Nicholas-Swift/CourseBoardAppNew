//
//  ProductUpdateTableViewCell.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 1/16/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit

class ProductUpdateTableViewCell: UITableViewCell {
    
    // Variabels
    var string: String! {
        didSet {
            setupLineSpacing(string: string)
        }
    }
    
    // UI Elements
    @IBOutlet weak var updateTypeLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    // Other
    
    func setupLineSpacing(string: String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        bodyLabel.attributedText = attrString
        
    }
    
}
