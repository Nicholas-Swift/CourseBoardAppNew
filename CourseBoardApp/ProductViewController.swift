//
//  ProductViewController.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/25/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    // Variables
    var product: Product?
    var productId: String! {
        didSet {
            CourseBoardAPI.getProduct(id: productId) { (product: Product?, error: NSError?) in
                
                if let _ = error {
                    return //error!
                }
                
                guard let product = product else {
                    return //error!
                }
                
                self.product = product
                self.tableView.reloadData()
                
                // Start loading up all updates
                CourseBoardAPI.getUpdates(productId: product.id!, complete: { (updates: [Update]?, error: NSError?) in
                    self.product?.updates = updates
                })
                
            }
        }
    }
    
    var currentSegment = 0
    
    // UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var belowNavView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emptySegmentLabel: UILabel!
    @IBOutlet weak var moreBarButton: UIBarButtonItem!
    
    // UI Actions
    @IBAction func moreBarAction(_ sender: Any) {
        setupActionView()
    }
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initially hide empty segment label
        emptySegmentLabel.isHidden = true
        
        // Setup Segmented Control
        setupSegmentedControl()
        
        // Setup Table View
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Setup style
        styleSetup()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "ToProfileViewController" {
            return
        }
        
        guard let indexPath = tableView.indexPathForSelectedRow, let students = product?.contributors else {
            return
        }
        
        let destination = segue.destination as! ProfileViewController
        destination.userId = students[indexPath.row].id
    }
    
}

// MARK: Style Setup
extension ProductViewController {
    
    func styleSetup() {
        
        // Set up Nav Bar style - To account for the segmented control
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(UIColor.white)
        self.navigationController?.navigationBar.isTranslucent = false
        
        // Set up title
        self.navigationItem.title = product?.name ?? ""
        
        // Set up view
        belowNavView.layer.masksToBounds = false
        belowNavView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        belowNavView.layer.shadowRadius = 0
        belowNavView.layer.shadowOpacity = 1
        belowNavView.layer.shadowColor = ColorHelper.redditLightGrayColor.cgColor
    }
    
}

// MARK: Segmented Control

extension ProductViewController {
    
    // Setup Segemnted Control
    func setupSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    // Value Changed
    func segmentedControlValueChanged() {
        let index = segmentedControl.selectedSegmentIndex
        currentSegment = index
        
        // Update style
        if currentSegment == 1 {
            tableView.separatorColor = UIColor.clear
        }
        else {
            tableView.separatorColor = ColorHelper.defaultSeparatorColor
        }
        
        // Update table view
        //tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: 0)
        tableView.reloadData()
        
        // Unhide empty string?
        if currentSegment == 0 {
            emptySegmentLabel.isHidden = true
        }
        else if currentSegment == 1 {
            
            emptySegmentLabel.text = "This product has no updates."
            
            guard let updates = product?.updates else {
                emptySegmentLabel.isHidden = true
                return
            }
            
            emptySegmentLabel.isHidden = updates.isEmpty ? false : true
        }
        else if currentSegment == 2 {
            
            emptySegmentLabel.text = "This product has no collaborators."
            
            guard let collaborators = product?.contributors else {
                emptySegmentLabel.isHidden = true
                return
            }
            
            emptySegmentLabel.isHidden = collaborators.isEmpty ? false : true
        }
    }
    
}

// MARK: More Bar Button Item
extension ProductViewController {
    
    func setupActionView() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        var leaveTuple: (String, UIAlertActionStyle, ((UIAlertAction) -> ())) = ("Join Product", .default, joinProduct)
        
        for contributor in (product?.contributors)! {
            if contributor.id == CourseBoardAPI.me?.id {
                leaveTuple = ("Leave Product", .destructive, leaveProduct)
                break
            }
        }
        
        let leaveProductAction = UIAlertAction(title: leaveTuple.0, style: leaveTuple.1, handler: leaveTuple.2)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(leaveProductAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func joinProduct(alert: UIAlertAction) {
        CourseBoardAPI.joinProduct(id: (product?.id)!) { (bool: Bool?, error: NSError?) in
            print("JOINED")
        }
    }
    
    func leaveProduct(alert: UIAlertAction) {
        CourseBoardAPI.leaveProduct(id: (product?.id)!) { (bool: Bool?, error: NSError?) in
            print("LEFT")
        }
    }
    
}

// MARK: Table View
extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // If index 0 -> info, product basics, business model canvas
        let index = segmentedControl.selectedSegmentIndex
        if index == 0 {
            return 3
        }
        else if index == 1 {
            return product?.updates?.count ?? 0
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
            return product?.contributors?.count ?? 0
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
            
            guard let count = product?.updates?.count else {
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
                return "Product Basics"
            }
            else {
                return "Business Model Canvas"
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentSegment {
        case 0:
            return InformationCellForRowSetup(indexPath: indexPath)
        case 1:
            return UpdatesCellForRowSetup(indexPath: indexPath)
        case 2:
            return CollaboratorsCellForRowSetup(indexPath: indexPath)
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInformationTableViewCell")
            return cell!
        }
    }
    
    
    // MARK: Information
    func InformationCellForRowSetup(indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInformationTableViewCell") as! ProductInformationTableViewCell
            
            switch(indexPath.row) {
            case 0:
                cell.linkLabel.text = "GitHub"
                break
            case 1:
                cell.linkLabel.text = "Scrum Board"
                break;
            case 2:
                cell.linkLabel.text = "Live Site"
                break;
            default:
                break;
            }
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductBasicsTableViewCell") as! ProductBasicsTableViewCell
            
            ProductBasicsSetup(cell: cell, indexPath: indexPath)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductBasicsTableViewCell") as! ProductBasicsTableViewCell
            
            BusinessModelCanvasSetup(cell: cell, indexPath: indexPath)
            
            return cell
        }
    }
    
    // MARK: Updates
    func UpdatesCellForRowSetup(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductUpdateTableViewCell") as! ProductUpdateTableViewCell
        
        cell.updateTypeLabel.text = product?.updates?[indexPath.section].kind ?? "NIL"
        cell.string = product?.updates?[indexPath.section].body ?? ""
        
        return cell
    }
    
    // MARK: Collaborators
    func CollaboratorsCellForRowSetup(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCollaboratorTableViewCell") as! ProductCollaboratorTableViewCell
        
        cell.fullNameLabel.text = product?.contributors?[indexPath.row].fullname ?? "NIL"
        cell.usernameLabel.text = product?.contributors?[indexPath.row].username ?? "NIL"
        
        return cell
    }
    
    func InformationNumberOfRowsSetup(section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            
            var returnNum = 0
            
            returnNum += product?.problem == nil ? 0 : 1
            returnNum += product?.assumptions == nil ? 0 : 1
            returnNum += product?.mvp == nil ? 0 : 1
            
            return returnNum
        case 2:
            
            var returnNum = 0
            
            returnNum += product?.customer == nil ? 0 : 1
            returnNum += product?.valueProposition == nil ? 0 : 1
            returnNum += product?.channels == nil ? 0 : 1
            returnNum += product?.customerRelationships == nil ? 0 : 1
            returnNum += product?.revenueStreams == nil ? 0 : 1
            returnNum += product?.keyActivities == nil ? 0 : 1
            returnNum += product?.keyResources == nil ? 0 : 1
            returnNum += product?.keyPartners == nil ? 0 : 1
            returnNum += product?.costStructure == nil ? 0 : 1
            
            return returnNum
        default:
            return 0
        }
    }
    
    func ProductBasicsSetup(cell: ProductBasicsTableViewCell, indexPath: IndexPath) {
        
        // Set up strings
        let problemString = "What problem are you solving?"
        let assumptionsString = "What are your assumptions?"
        let mvpString = "Describe your minimum viable product."
        
        let basicsArray: [(String?, String)] = [(product?.problem, problemString), (product?.assumptions, assumptionsString), (product?.mvp, mvpString)]
        
        let myArray: [(String?, String)] = basicsArray.filter { (string: String?, type: String) in
            if string != nil {
                return true
            }
            return false
        }
        
        cell.string = myArray[indexPath.row].0
        cell.typeLabel.text = myArray[indexPath.row].1
        
    }
    
    func BusinessModelCanvasSetup(cell: ProductBasicsTableViewCell, indexPath: IndexPath) {
        
        // Set up strings
        let customerString = "Who is your customer?"
        let valueString = "What value do you bring?"
        let channelsString = "How do you reach your customers?"
        let relationshipsString = "What relationships will you form?"
        let revenueString = "What streams of revenue will you receive?"
        let activitiesString = "What key activities will you engage in?"
        let resourcesString = "What key resources will you require?"
        let partnersString = "What key partners do you need?"
        let costString = "What are your key costs?"
        
        let businessArray: [(String?, String)] = [(product?.customer, customerString),
                (product?.valueProposition, valueString),
                (product?.channels, channelsString),
                (product?.customerRelationships, relationshipsString),
                (product?.revenueStreams, revenueString),
                (product?.keyActivities, activitiesString),
                (product?.keyResources, resourcesString),
                (product?.keyPartners, partnersString),
                (product?.costStructure, costString)]
        
        let myArray: [(String?, String)] = businessArray.filter { (string: String?, type: String) in
            if string != nil {
                return true
            }
            return false
        }
        
        cell.string = myArray[indexPath.row].0
        cell.typeLabel.text = myArray[indexPath.row].1
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            var link = ""
            
            switch(indexPath.row) {
            case 0:
                guard let github = product?.githubUrl else {
                    
                    let alert = UIAlertController(title: "No GitHub link", message: "This product does not have a GitHub link", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                link = github
                break
            case 1:
                guard let agile = product?.agileUrl else {
                    
                    let alert = UIAlertController(title: "No scrum board link", message: "This product does not have a scrum board link", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                link = agile
                break
            case 2:
                guard let live = product?.liveUrl else {
                    
                    let alert = UIAlertController(title: "No live link", message: "This product does not have a live link", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                link = live
                break
            default:
                break
            }
            
            let url = URL(string: link)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
