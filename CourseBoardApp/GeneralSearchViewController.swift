//
//  GeneralSearchViewController.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 1/16/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GeneralSearchViewController: UIViewController {
    
    // Variables
    var disposeBag = DisposeBag()
    var courses: Variable<[Course]> = Variable([])
    
    // UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup style
        //styleSetup()
        
        // Setup functionality
        functionalitySetup()
    }
    
}

// MARK: Functionality Setup

extension GeneralSearchViewController {
    
    func functionalitySetup() {
        
        // Add courses
        addCourses()
        
        // Remove tableView delegate, dataSource
        tableView.delegate = nil
        tableView.dataSource = nil
        
        // Bind to tableView
        courses.asObservable().bindTo(tableView.rx.items(cellIdentifier: "PostCourseTableViewCell", cellType: UITableViewCell.self)) { (index: Int, course: Course, cell: UITableViewCell) in
            cell.textLabel?.text = course.title
            }.addDisposableTo(disposeBag)
        
        // Bind tap
        tableView.rx.itemSelected.subscribe(onNext: cellTapped).addDisposableTo(disposeBag)
    }
    
    func addCourses() {
        self.courses.value = []
        
        // Add courses
        CourseBoardAPI.getCourses { (courses: [Course]?, error: NSError?) in
            if let _ = error {
                return // error!
            }
            
            guard let courses = courses else {
                return // error!
            }
            
            self.courses.value = courses
        }
    }
    
    func cellTapped(indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
