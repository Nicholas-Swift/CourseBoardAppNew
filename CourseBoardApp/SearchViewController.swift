//
//  SearchViewController.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/25/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    // Variables
    var searchController: UISearchController!
    
    var disposeBag = DisposeBag()
    
    let users: Variable<[User]> = Variable([])
    var usersImg: [String: UIImage] = [:]
    let filteredUsers: Variable<[User]> = Variable([])
    
    // UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup style
        styleSetup()
        
        // Setup Functionality
        functionalitySetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return // no index path
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ProfileViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return // error!
        }
        
        print("username: \(filteredUsers.value[indexPath.row].fullname)")
        print("id: \(filteredUsers.value[indexPath.row].id)")
        
        destination.userId = filteredUsers.value[indexPath.row].id
    }
}

// MARK: Functionality Setup
extension SearchViewController {
    
    func functionalitySetup() {
        
        // Add users to users and filteredUsers
        addUsers()
        
        // Search Observable
        let searchObservable: Observable<String?> = searchController.searchBar.rx.text.asObservable()
        searchObservable.subscribe(onNext: filterUsers).addDisposableTo(disposeBag)
        
        // Search cancel button
        searchController.searchBar.rx.cancelButtonClicked.subscribe(onNext: cancelSearch).addDisposableTo(disposeBag)
        
        // Remove tableView delegate, dataSource
        tableView.delegate = nil
        tableView.dataSource = nil
        
        // Bind to tableView
        filteredUsers.asObservable().bindTo(tableView.rx.items(cellIdentifier: "SearchUserTableViewCell", cellType: SearchUserTableViewCell.self)) { (index: Int, user: User, cell: SearchUserTableViewCell) in
            cell.user = user
        }.addDisposableTo(disposeBag)
    }
    
    func cancelSearch() {
        filteredUsers.value = users.value
    }
    
    func filterUsers(text: String?) {
        
        // If text is nil
        guard let text = text?.lowercased() else {
            filteredUsers.value = users.value
            return
        }
        
        // If text is empty
        if text == "" {
            filteredUsers.value = users.value
            return
        }
        
        // Filter!
        var newValue: [User] = []
        for user in users.value {
            
            let fullname = user.fullname!.lowercased()
            let username = user.username!.lowercased()
            
            if fullname.contains(text) || username.contains(text) {
                newValue.append(user)
            }
        }
        self.filteredUsers.value = newValue
        
    }
    
    func addUsers() {
        
        self.users.value = []
        self.filteredUsers.value = []
        
        // Add instructors
        CourseBoardAPI.getInstructors { (instructors: [User]?, error: NSError?) in
            if error == nil {
                guard let instructors = instructors else {
                    return //error!
                }
                self.users.value.append(contentsOf: instructors)
                self.filteredUsers.value.append(contentsOf: instructors)
            }
            else {
                //error!
            }
        }
        
        // Add students
        CourseBoardAPI.getStudents { (students: [User]?, error: NSError?) in
            if error == nil {
                guard let students = students else {
                    return //error!
                }
                self.users.value.append(contentsOf: students)
                self.filteredUsers.value.append(contentsOf: students)
            }
            else {
                //error!
            }
        }
        
    }
    
}

// MARK: Style Setup
extension SearchViewController {
    
    func styleSetup() {
        
        // Set up Nav Bar style
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(ColorHelper.redditLightGrayColor)
        self.navigationController?.navigationBar.isTranslucent = false
        
        // Set up tableView
        tableView.separatorColor = ColorHelper.redditLightGrayColor
        
        // Set up search bar
        searchSetup()
    }
    
    func searchSetup() {
        self.searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        
        // Change searchBar background color
        for view in self.searchController.searchBar.subviews {
            for subview in view.subviews {
                if subview.isKind(of: UITextField.self) {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = ColorHelper.searchBarBackgroundColor
                }
            }
        }
        
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
    }
    
}
