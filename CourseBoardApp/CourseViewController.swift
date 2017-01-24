//
//  CourseViewController.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/9/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

enum CourseSegments {
    case information
    case posts
    case participants
}

class CourseViewController: UIViewController {

    // Variables
    var course: Course?
    var courseId: String! {
        didSet {
            CourseBoardAPI.getCourse(id: courseId) { (course: Course?, error: NSError?) in
                
                if let _ = error {
                    return //error!
                }
                
                guard let course = course else {
                    return //error!
                }
                
                self.course = course
                self.tableView.reloadData()
            }
        }
    }
    
    var currentSegment = 0
    
    // Hiding nav bar
    var dragUpOrDown: Bool = false
    var prevScroll: CGFloat = 0
    var barUp: Bool = true
    
    // UI Elements
    
    @IBOutlet weak var moreBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var belowNavView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emptySegmentLabel: UILabel!
    
    // UI Actions
    @IBAction func moreBarAction(_ sender: Any) {
        setupActionView()
    }
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initially hide emptySegment
        emptySegmentLabel.isHidden = true
        
        // Setup Segmented Control
        setupSegmentedControl()
        
        // Setup Table View
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Setup style
        styleSetup()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "ToProfileViewController" {
            return
        }
        
        guard let indexPath = tableView.indexPathForSelectedRow, let students = course?.students else {
            return
        }
        
        let destination = segue.destination as! ProfileViewController
        destination.userId = students[indexPath.row].id
    }

}

// MARK: Style Setup
extension CourseViewController {
    
    func styleSetup() {
        
        // Set up Nav Bar style - To account for the segmented control
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(UIColor.white)
        self.navigationController?.navigationBar.isTranslucent = false
        
        // Set up title
        self.navigationItem.title = course?.title ?? ""
        
        // Set up view
        belowNavView.layer.masksToBounds = false
        belowNavView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        belowNavView.layer.shadowRadius = 0
        belowNavView.layer.shadowOpacity = 1
        belowNavView.layer.shadowColor = ColorHelper.redditLightGrayColor.cgColor
    }
    
}

// MARK: Segmented Control

extension CourseViewController {
    
    // Setup Segemnted Control
    func setupSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    // Value Changed
    func segmentedControlValueChanged() {
        let index = segmentedControl.selectedSegmentIndex
        currentSegment = index
        
        // Change style
        if currentSegment == 1 {
            tableView.separatorColor = UIColor.clear
        }
        else {
            tableView.separatorColor = ColorHelper.defaultSeparatorColor
        }
        
        // Reload table view
        //tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: 0)
        tableView.reloadData()
        
        // Unhide empty string?
        if currentSegment == 0 {
            emptySegmentLabel.isHidden = true
        }
        else if currentSegment == 1 {
            
            emptySegmentLabel.text = "This course has no posts."
            
            guard let posts = course?.posts else {
                emptySegmentLabel.isHidden = true
                return
            }
            
            emptySegmentLabel.isHidden = posts.isEmpty ? false : true
        }
        else if currentSegment == 2 {
            
            emptySegmentLabel.text = "This course has no participants."
            
            guard let students = course?.students else {
                emptySegmentLabel.isHidden = true
                return
            }
            
            emptySegmentLabel.isHidden = students.isEmpty ? false : true
        }
    }
    
}

// MARK: More Bar Button Item
extension CourseViewController {
    
    func setupActionView() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let newPostAction = UIAlertAction(title: "New Post", style: .default, handler: nil)
        
        let unenrollCourseAction = UIAlertAction(title: "Unenroll Course", style: .destructive, handler: nil)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(newPostAction)
        alert.addAction(unenrollCourseAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

// MARK: Table View

extension CourseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // If index 0 -> info, description, objectives
        let index = segmentedControl.selectedSegmentIndex
        if index == 0 {
            return 3
        }
        else if index == 1 {
            return course?.posts?.count ?? 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = segmentedControl.selectedSegmentIndex
        if index == 0 {
            return InformationNumberOfRowsSetup(section: section)
        }
        else if index == 1 {
            return 1
        }
        else if index == 2 {
            return course?.students?.count ?? 0
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        // If index 0
        let index = segmentedControl.selectedSegmentIndex
        if index == 0 {
            if section == 0 {
                return 45
            }
            return 15
        }
        else if index == 1 {
            if section == 0 {
                return 10
            }
            return 5
        }
        
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let index = segmentedControl.selectedSegmentIndex
        if index == 0 {
            return 30
        }
        else if index == 1 {
            guard let count = course?.posts?.count else {
                return 5
            }
            
            if section == count - 1 {
                return 10
            }
            
            return 5
        }
        
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let index = segmentedControl.selectedSegmentIndex
        if index == 0 {
            if section == 0 {
                return "Information"
            }
            else if section == 1 {
                return "Description"
            }
            else {
                return "Objectives"
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = segmentedControl.selectedSegmentIndex
        switch index {
        // Description
        case 0:
            return InformationCellForRowSetup(indexPath: indexPath)
        // Posts
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoursePostTableViewCell") as! CoursePostTableViewCell
            cell.fullnameLabel.text = course?.posts?[indexPath.section].user?.fullname ?? "NIL"
            //cell.dateLabel.text = course?.posts?[indexPath.section]
            cell.body = course?.posts?[indexPath.section].body ?? "NIL"
            return cell
            
        // Participants
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourseParticipantTableViewCell") as! CourseParticipantTableViewCell
            cell.nameLabel.text = course?.students?[indexPath.row].fullname ?? "NIL"
            cell.usernameLabel.text = course?.students?[indexPath.row].username ?? "NIL"
            return cell

        default:
            break
        }
        
        // Incase switch statement fails!!
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoursePostTableViewCell") as! CoursePostTableViewCell
        return cell
    }
    
    // MARK: Information
    
    func InformationCellForRowSetup(indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourseInformationTableViewCell") as! CourseInformationTableViewCell
            
            let info = InformationInformationSetup(row: indexPath.row)
            cell.typeLabel.text = info.0
            cell.infoLabel.text = info.1
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourseObjectiveTableViewCell") as! CourseObjectiveTableViewCell
            cell.desc = course?.description ?? ""
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourseObjectiveTableViewCell") as! CourseObjectiveTableViewCell
            cell.desc = course?.objectives?[indexPath.row] ?? "NIL"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoursePostTableViewCell")
            return cell!
        }
    }
    
    func InformationNumberOfRowsSetup(section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        case 2:
            return course?.objectives?.count ?? 0
        default:
            return 0
        }
    }
    
    func InformationInformationSetup(row: Int) -> (String, String) {
        switch(row) {
        case 0:
            return ("Instructor:", course?.instructor?.fullname ?? "NIL")
        case 1:
            return ("Days:", course?.weekdays ?? "NIL")
        case 2:
            return ("Time:", course?.startTime ?? "NIL")
        case 3:
            return ("Location:", course?.location ?? "NIL")
        default:
            return ("ERR", "ERR")
        }
    }
    
}

