//
//  TopTabBar.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/10/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import Foundation
import UIKit

class TopTabBar: UIView {
    
    // Variables
    
    var selectedSegmentIndex = 0
    var buttons: [UIButton] = []
    
    // Functions
    
    init(titles: [String], frame: CGRect) {
        super.init(frame: frame)
        
        // Append all buttons
        setupButtons(titles: titles)
        
        // Set up the button's frames
        setupFrames(frame: frame)
        
    }
    
    func setupButtons(titles: [String]) {
        for title in titles {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor.lightGray, for: .normal)
            button.setTitleColor(UIColor.blue, for: .selected)
            button.backgroundColor = UIColor.yellow
            button.isSelected = false
            buttons.append(button)
        }
        
        buttons[0].isSelected = true
    }
    
    func setupFrames(frame: CGRect) {
        
        let height = frame.height
        let width = frame.width / CGFloat(buttons.count)
        
        for (index, button) in buttons.enumerated() {
            
            let x = CGFloat(index) * width
            let y = CGFloat(0)
            
            button.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
