//
//  FeedViewController.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/7/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    // Variables
    
    var refreshControl: UIRefreshControl!
    
    var posts: [Post] = []
    
    // UI Elements
    
    @IBOutlet weak var moreBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // UI Actions
    @IBAction func moreBarButtonAction(_ sender: UIBarButtonItem) {
        setupActionView()
    }
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Style Setup
        styleSetup()
        
        // Set up tableView
        tableView.separatorColor = UIColor.clear
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set up refresh control
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        
        // Functionality Setup
        functionalitySetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

// MARK: Functionality
extension FeedViewController {
    
    func functionalitySetup() {
        
        CourseBoardAPI.login(email: "---", password: "---") { (bool: Bool, error: NSError?) in
            // Get posts
            CourseBoardAPI.getPostsFromEnrolledCourses(userId: "578524a4a4e38b03006a2be6", complete: { (posts: [Post]?, error: NSError?) in
                if error == nil {
                    
                    guard let posts = posts else {
                        return // error happened
                    }
                    
                    // Update posts and tableview
                    self.posts = posts
                    self.tableView.reloadData()
                    
                }
                else {
                    // error happened
                }
            })
        }
        
    }
    
}

// MARK: Style Setup
extension FeedViewController {
    
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

// MARK: More Bar Button Item
extension FeedViewController {
    
    func setupActionView() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let newPostAction = UIAlertAction(title: "New Post", style: .default) { (action: UIAlertAction) in
            self.performSegue(withIdentifier: "toNewPostViewController", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(newPostAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

// MARK: Table View

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == tableView.numberOfSections - 1 {
            return 10
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedPostTableViewCell") as! FeedPostTableViewCell
        let post = posts[indexPath.section]
        
        cell.post = post
        
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedPostTableViewCellTemp") as! FeedPostTableViewCellTemp
//        let post = posts[indexPath.section]
//        
//        cell.post = post
//        
//        return cell
    }
    
}
