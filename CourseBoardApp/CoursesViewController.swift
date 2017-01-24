//
//  CoursesViewController.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/8/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CoursesViewController: UIViewController {

    // Variables
    var disposeBag = DisposeBag()
    
    var refreshControl: UIRefreshControl!
    
    var courses: Variable<[SectionModel<String?, Course>]> = Variable([])
    
    // UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Style Setup
        styleSetup()
        
        // Set up tableView
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set up refresh control
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        
        // Functionality Setup
        functionalitySetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        styleSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Return if not correct identifier
        if segue.identifier != "ToCourseViewController" {
            return
        }
        
        let destination = segue.destination as! CourseViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        let c = courses.value[indexPath.section].items[indexPath.row]
        destination.course = c
        destination.courseId = c.id
    }

}

// MARK: Functionality Setup
extension CoursesViewController {
    
    func functionalitySetup() {
        
        // Add courses
        addCourses()
        
        // Set up refresh control
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: addCourses).addDisposableTo(disposeBag)
        
        // Set tableView delegate, dataSource
        tableView.delegate = self
        tableView.dataSource = nil
        
        // Set up dataSource
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String?, Course>>()
        
        dataSource.configureCell = { source, tableView, indexPath, course in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoursesCourseTableViewCell") as! CoursesCourseTableViewCell
            cell.course = course
            return cell
        }
        
        dataSource.titleForHeaderInSection = { source, indexPath in
            return self.courses.value[indexPath].model
        }
        
        // Bind to tableView
        courses.asObservable().bindTo(tableView.rx.items(dataSource: dataSource)).addDisposableTo(disposeBag)
        
    }
    
    func addCourses() {
        
        // Get courses
        CourseBoardAPI.getCourses { (courses: [Course]?, error: NSError?) in
            
            // Refresh control
            self.refreshControl.endRefreshing()
            self.courses.value = []
            
            if let _ = error {
                return // error!
            }
            
            guard let courses = courses else {
                return // error!
            }
            
            // Add to courses
            self.courses.value.append(SectionModel(model: "Quarter 4", items: courses.filter{$0.quarter == "4"}))
            self.courses.value.append(SectionModel(model: "Quarter 3", items: courses.filter{$0.quarter == "3"}))
            self.courses.value.append(SectionModel(model: "Quarter 2", items: courses.filter{$0.quarter == "2"}))
            self.courses.value.append(SectionModel(model: "Quarter 1", items: courses.filter{$0.quarter == "1"}))
            
            // Filter emtpy quarters
            self.courses.value = self.courses.value.filter {!$0.items.isEmpty}
        }
    }
    
}

// MARK: Style Setup
extension CoursesViewController {
    
    func styleSetup() {
        // Set up Tab Bar style
        self.tabBarController?.tabBar.layer.borderWidth = 0.5
        self.tabBarController?.tabBar.layer.borderColor = ColorHelper.redditLightGrayColor.cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        self.tabBarController?.tabBar.isTranslucent = false
        
        // Set up Nav Bar style
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(ColorHelper.redditLightGrayColor)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
}

// MARK: Table View

extension CoursesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 50
        }
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
