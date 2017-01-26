//
//  ProductsViewController.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/7/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ProductsViewController: UIViewController {

    // Variables
    var disposeBag = DisposeBag()
    
    var refreshControl: UIRefreshControl!
    
    var products: Variable<[SectionModel<String?, Product>]> = Variable([])
    
    // UI Elements
    @IBOutlet weak var tableView: UITableView!
    
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
        if segue.identifier != "ToProductViewController" {
            return
        }
        
        let destination = segue.destination as! ProductViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        let p = products.value[indexPath.section].items[indexPath.row]
        destination.product = p
        destination.productId = p.id
    }
    
}

// MARK: Functionality
extension ProductsViewController {
    
    func functionalitySetup() {
        
        // Add products
        addProducts()
        
        // Set up refresh control
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: addProducts).addDisposableTo(disposeBag)
        
        // Set tableView delegate, dataSource
        tableView.delegate = self
        tableView.dataSource = nil
        
        // Set up dataSource
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String?, Product>>()
        
        dataSource.configureCell = { source, tableView, indexPath, product in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsProductTableViewCell") as! ProductsProductTableViewCell
            cell.product = product
            return cell
        }
        
        dataSource.titleForHeaderInSection = { source, indexPath in
            return nil
        }
        
        // Bind to tableView
        products.asObservable().bindTo(tableView.rx.items(dataSource: dataSource)).addDisposableTo(disposeBag)
        
        // Add click
        
    }
    
    func addProducts() {
        
        // Refresh control
        self.refreshControl.endRefreshing()
        
        // Get products
        CourseBoardAPI.getCurrentProducts { [weak self] (products: [Product]?, error: NSError?) in
            if error == nil {
                
                guard let products = products else {
                    return // error!
                }
                
                let filteredProducts = products.filter{$0.liveUrl != nil}
                
                // Set up sections
                self?.products.value = filteredProducts.map {SectionModel(model: nil, items: [$0])}
            }
            else {
                // error!
            }
        }
    }
    
}

// MARK: More Table View
extension ProductsViewController: UITableViewDelegate {
    
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
    
}

// MARK: Style Setup
extension ProductsViewController {
    
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
