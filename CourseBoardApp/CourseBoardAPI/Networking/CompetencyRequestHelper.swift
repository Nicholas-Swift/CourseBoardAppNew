//
//  CompetencyRequestHelper.swift
//  CourseBoardAPI
//
//  Created by Nicholas Swift on 10/23/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension CourseBoardAPI {
    
    // MARK: Update competence -- READY
    static func updateCompetence(userId: String, competency: Competency, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/user/\(userId)/feedback"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Set up parameters with course
        var parameters: [String: AnyObject] = [:]
        
        // Check name, check body
        
        if let name = competency.name {
            parameters["name"] = name as AnyObject
        } else {
            complete(false, NSError(domain: "Invalid competency name", code: 400, userInfo: nil))
        }
        
        if let level = competency.level {
            parameters["level"] = level as AnyObject?
        } else {
            complete(false, NSError(domain: "Competency has invalid level", code: 400, userInfo: nil))
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
    
}
