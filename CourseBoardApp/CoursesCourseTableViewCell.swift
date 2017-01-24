//
//  CoursesCourseTableViewCell.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/8/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class CoursesCourseTableViewCell: UITableViewCell {

    // Variables
    var course: Course! {
        didSet {
            
            titleLabel.text = course.title
            instructorLabel.text = course.instructor?.fullname
            daysLabel.text = course.weekdays
            participantsLabel.text = "\(course.students?.count ?? 0)"
            timeLabel.text = course.startTime
            
        }
    }
    
    // UI Elements
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instructorLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

}
