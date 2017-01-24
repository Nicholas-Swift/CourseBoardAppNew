//
//  ProfileViewController.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/26/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

enum ProfileSegmentedControl {
    case courses
    case products
    case feedback
}

class ProfileViewController: UIViewController {
    
    // Variables
    
    var userId: String?
    var user: User? {
        didSet {
            products = user?.products ?? []
            
            // Set up courses
            let enrolledCourses = user?.enrolledCourses ?? []
            let quarter4: [Course] = enrolledCourses.filter{$0.quarter == "4"}
            let quarter3: [Course] = enrolledCourses.filter{$0.quarter == "3"}
            let quarter2: [Course] = enrolledCourses.filter{$0.quarter == "2"}
            let quarter1: [Course] = enrolledCourses.filter{$0.quarter == "1"}
            
            // Append to courses
            if !quarter4.isEmpty {
                courses.append(quarter4)
                coursesHeaders.append("Quarter 4")
            }
            if !quarter3.isEmpty {
                courses.append(quarter3)
                coursesHeaders.append("Quarter 3")
            }
            if !quarter2.isEmpty {
                courses.append(quarter2)
                coursesHeaders.append("Quarter 2")
            }
            if !quarter1.isEmpty {
                courses.append(quarter1)
                coursesHeaders.append("Quarter 1")
            }
            
            // Reload table view
            tableView.reloadData()
        }
    }
    var products: [Product] = []
    var courses: [[Course]] = []
    var coursesHeaders: [String] = []
    
    var currentSegment = ProfileSegmentedControl.courses {
        didSet {
            tableView.reloadData()
        }
    }
    
    // UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    // UI Actions
    
    @IBAction func coursesSegmentAction(_ sender: Any) {
        currentSegment = ProfileSegmentedControl.courses
    }
    @IBAction func productsSegmentAction(_ sender: Any) {
        currentSegment = ProfileSegmentedControl.products
    }
    @IBAction func feedbackSegmentAction(_ sender: Any) {
        currentSegment = ProfileSegmentedControl.feedback
    }
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Setup Style
        styleSetup()
        
        // Setup Functionality
        functionalitySetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: Functionality Setup
extension ProfileViewController {
    
    func functionalitySetup() {
        // Add products
        addUser()
    }
    
    func addUser() {
        
        // Get other User
        if let userId = self.userId {
            
            CourseBoardAPI.getUser(id: userId, complete: { (user: User?, error: NSError?) in
                if let _ = error {
                    return // error!
                }
                
                guard let user = user else {
                    return // error!
                }
                
                self.user = user
            })
            
            return
        }
        
        // Get Self
        CourseBoardAPI.getMe { (user: User?, error: NSError?) in
            if let _ = error {
                return // error!
            }
            
            guard let user = user else {
                return // error!
            }
            
            self.user = user
        }
    }
    
}

// MARK: Style Setup
extension ProfileViewController {
    
    func styleSetup() {
        // Set up Nav Bar style
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(ColorHelper.redditLightGrayColor)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
}

// MARK: Table View
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var num = 0
        
        switch(currentSegment) {
        case ProfileSegmentedControl.courses:
            num = courses.count
        case ProfileSegmentedControl.products:
            num = products.count
        default:
            break
        }
        
        return 2 + num
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if currentSegment == ProfileSegmentedControl.courses, !courses.isEmpty, section > 1 {
            return courses[section - 2].count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // If not courses, ignore
        if currentSegment != ProfileSegmentedControl.courses {
            return nil
        }
        
        if section > 1 {
            return coursesHeaders[section - 2]
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0.001
        }
        
        // Course sections
        if currentSegment == ProfileSegmentedControl.courses, section > 1 {
            return 50
        }
        
        // First real section
        if section == 2 {
            return 10
        }
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0.001
        }
        
        // Last section
        if section == tableView.numberOfSections - 1 {
            return 10
        }
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 44
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderTableViewCell") as! ProfileHeaderTableViewCell
            if let user = self.user {
                cell.user = user
            }
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSegmentedControlTableViewCell")
            return cell!
        }
        else {
            switch currentSegment {
            case .courses:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCourseTableViewCell") as! ProfileCourseTableViewCell
                if self.user != nil {
                    let course = courses[indexPath.section - 2][indexPath.row]
                    cell.course = course
                }
                return cell
            case .products:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileProductTableViewCell") as! ProfileProductTableViewCell
                if self.user != nil {
                    let product = products[indexPath.section - 2]
                    cell.product = product
                }
                return cell
            case .feedback:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileProductTableViewCell")
                return cell!
            }
        }
    }
    
}
