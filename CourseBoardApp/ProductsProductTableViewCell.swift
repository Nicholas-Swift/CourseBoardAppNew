//
//  ProductsProductTableViewCell.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/7/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class ProductsProductTableViewCell: UITableViewCell {
    
    // Variables
    var product: Product! {
        didSet {
            
            titleLabel.text = product.name
            dateLabel.text = DateHelper.toLabelText(date: product.createdAt!)
            setupLineSpacing(string: product.problem ?? "")
            
        }
    }
    
    // UI Elements
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var desciptionLabel: UILabel!
    
    // Table View Cell
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupLineSpacing(string: String) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        desciptionLabel.attributedText = attrString
        
    }

}
