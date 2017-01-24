//
//  UpdateRequestHelper.swift
//  CourseBoardAPI
//
//  Created by Nicholas Swift on 10/23/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension CourseBoardAPI {
    
    // MARK: Get Updates -- DONE
    static func getUpdates(productId: String, complete: @escaping ( _ updates: [Update]?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/products/\(productId)/updates"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Request the data from api
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON() { response in
            
            switch response.result {
                
            // Success
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    var updates: [Update] = []
                    for i in json {
                        
                        let body = i.1 // Json
                        
                        let update = Update(json: body)
                        
                        updates.append(update)
                    }
                    
                    complete(updates, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error:")
                print(error)
                complete(nil, error as NSError?)
            }
        }
    }
    
    // MARK: Create Update -- READY
    static func createUpdate(productId: String, update: Update, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/products/\(productId)/updates"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Set up parameters with course
        var parameters: [String: AnyObject] = [:]
        
        // CHeck user, check body
        
        if let user = update.user?.id {
            parameters["user"] = user as AnyObject
        } else {
            complete(false, NSError(domain: "Invalid user id", code: 400, userInfo: nil))
        }
        
        if let body = update.body {
            parameters["body"] = body as AnyObject?
        } else {
            complete(false, NSError(domain: "Update has no body -> very lonely", code: 400, userInfo: nil))
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
                print("error:")
                print(error)
                complete(false, error as NSError?)
            }
        }
        
    }
    
    // MARK: Update updates -- READY
    static func updateUpdate(updateId: String, update: Update, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/updates/\(updateId)"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Set up parameters with course
        var parameters: [String: AnyObject] = [:]
        
        // CHeck user, check body
        
        if let user = update.user?.id {
            parameters["user"] = user as AnyObject
        } else {
            complete(false, NSError(domain: "Invalid user id", code: 400, userInfo: nil))
        }
        
        if let body = update.body {
            parameters["body"] = body as AnyObject?
        } else {
            complete(false, NSError(domain: "Update has no body -> very lonely", code: 400, userInfo: nil))
        }
        
        // Request the data from api
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON() { response in
            
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
                print("error:")
                print(error)
                complete(false, error as NSError?)
            }
        }
        
    }
    
    // MARK: Delete update -- READY
    static func deleteUpdate(updateId: String, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/updates/\(updateId)"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Request the data from api
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON() { response in
            
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
                print("error:")
                print(error)
                complete(false, error as NSError?)
            }
        }
        
    }
    
}
