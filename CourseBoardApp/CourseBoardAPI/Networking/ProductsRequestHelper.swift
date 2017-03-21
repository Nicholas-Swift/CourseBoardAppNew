//
//  ProductsRequestHelper.swift
//  CourseBoardAPI
//
//  Created by Nicholas Swift on 10/17/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension CourseBoardAPI {
    
    // MARK: Get Current Products -- DONE
    static func getCurrentProducts(complete: @escaping ( _ products: [Product]?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/products"
        let url = CourseBoardAPI.baseUrl + path
        
        // Request the data from api
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON() { response in
            
            switch response.result {
            
            // Success
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    var products: [Product] = []
                    for i in json {
                        
                        let body = i.1 // Json
                        
                        let course = Product(json: body)
                        
                        products.append(course)
                    }
                    
                    products = products.filter {$0.liveUrl != nil && $0.liveUrl != ""}
                    
                    complete(products, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(nil, error as NSError?)
            }
        }
    }
    
    // MARK: Get Specific Product -- DONE
    static func getProduct(id: String, complete: @escaping ( _ product: Product?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/products/\(id)"
        let url = CourseBoardAPI.baseUrl + path
        
        // Request the data from api
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON() { response in
            
            switch response.result {
                
            // Success
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let product = Product(json: json)
                    
                    complete(product, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(nil, error as NSError?)
            }
        }
        
    }
    
    // MARK: Create Product -- Done
    static func createProduct(product: Product, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/products"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Set up parameters with course
        var parameters: [String: AnyObject] = [:]
        
        // name, githubUrl, agileUrl, liveUrl
        if let name = product.name {
            parameters["name"] = name as AnyObject?
        }
        if let githubUrl = product.githubUrl {
            parameters["githubUrl"] = githubUrl as AnyObject?
        }
        if let agileUrl = product.agileUrl {
            parameters["agileUrl"] = agileUrl as AnyObject?
        }
        if let liveUrl = product.liveUrl {
            parameters["liveUrl"] = liveUrl as AnyObject?
        }
        
        // problem, customer, assumptions, finishedProduct, mvp
        if let problem = product.problem {
            parameters["problem"] = problem as AnyObject?
        }
        if let assumptions = product.assumptions {
            parameters["assumptions"] = assumptions as AnyObject?
        }
        if let finishedProduct = product.finishedProduct {
            parameters["finishedProduct"] = finishedProduct as AnyObject?
        }
        if let mvp = product.mvp {
            parameters["mvp"] = mvp as AnyObject?
        }
        
        // marketFit, nps
        if let marketFit = product.marketFit {
            parameters["marketFit"] = marketFit as AnyObject?
        }
        if let nps = product.nps {
            parameters["nps"] = nps as AnyObject?
        }
        
        // customer, valueProposition, channels, customerRelationships, revenueStreams, keyActivities, keyResources, keyPartners, costStructure
        if let customer = product.customer {
            parameters["customer"] = customer as AnyObject?
        }
        if let valueProposition = product.valueProposition {
            parameters["valueProposition"] = valueProposition as AnyObject?
        }
        if let channels = product.channels {
            parameters["channels"] = channels as AnyObject?
        }
        if let customerRelationships = product.customerRelationships {
            parameters["customerRelationships"] = customerRelationships as AnyObject?
        }
        if let revenueStreams = product.revenueStreams {
            parameters["revenueStreams"] = revenueStreams as AnyObject?
        }
        if let keyActivities = product.keyActivities {
            parameters["keyActivities"] = keyActivities as AnyObject?
        }
        if let keyResources = product.keyResources {
            parameters["keyResources"] = keyResources as AnyObject?
        }
        if let keyPartners = product.keyPartners {
            parameters["keyPartners"] = keyPartners as AnyObject?
        }
        if let costStructure = product.costStructure {
            parameters["costStructure"] = costStructure as AnyObject?
        }
        
        // course, instructor
        if let course = product.course?.id {
            parameters["course"] = course as AnyObject?
        }
        if let instructor = product.instructor?.id {
            parameters["instructor"] = instructor as AnyObject?
        }
        
        // Request the data from api
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON() { response in
            
            switch response.result {
                
            // Success
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    print(json)
                    
                    complete(true, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(false, error as NSError?)
            }
        }
        
    }
    
    // MARK: Update Product -- READY
    static func updateProduct(product: Product, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/products"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Set up parameters with course
        var parameters: [String: AnyObject] = [:]
        
        if let instructor = product.instructor?.id {
            parameters["instructor"] = instructor as AnyObject?
        } else {
            complete(false, NSError(domain: "No product instructor id", code: 400, userInfo: nil))
        }
        
        if let name = product.name {
            parameters["name"] = name as AnyObject?
        } else {
            complete(false, NSError(domain: "No product name", code: 400, userInfo: nil))
        }
        
        if let course = product.course?.id {
            parameters["course"] = course as AnyObject?
        } else {
            complete(false, NSError(domain: "No product course id", code: 400, userInfo: nil))
        }
        
        if let problem = product.problem {
            parameters["problem"] = problem as AnyObject?
        } else {
            complete(false, NSError(domain: "No product problem", code: 400, userInfo: nil))
        }
        
        // Request the data from api
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON() { response in
            
            switch response.result {
                
            // Success
            case .success:
                if let _ = response.result.value {
                    complete(true, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(false, error as NSError?)
            }
        }
    }
    
    // MARK: Delete Product -- DONE
    static func deleteProduct(id: String, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and resource
        let path = "/api/products/\(id)"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Request the data from api
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON() { response in
            
            switch response.result {
                
            // Success
            case .success:
                if let _ = response.result.value {
                    complete(true, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(false, error as NSError?)
            }
        }
        
    }
    
    // MARK: Join Product -- DONE
    static func joinProduct(id: String, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and resource
        let path = "/api/products/\(id)/join"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Request the data from api
        Alamofire.request(url, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON() { response in
            
            switch response.result {
                
            // Success
            case .success:
                if let _ = response.result.value {
                    complete(true, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(false, error as NSError?)
            }
        }
        
    }
    
    // MARK: Leave Product -- DONE
    static func leaveProduct(id: String, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and resource
        let path = "/api/products/\(id)/leave"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers and parameters
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Request the data from api
        Alamofire.request(url, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON() { response in
            
            switch response.result {
            
            // Success
            case .success:
                if let _ = response.result.value {
                    complete(true, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(false, error as NSError?)
            }
        }
        
    }
    
}
