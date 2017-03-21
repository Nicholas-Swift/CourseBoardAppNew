//
//  UserRequestHelper.swift
//  CourseBoardAPI
//
//  Created by Nicholas Swift on 10/22/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa

extension CourseBoardAPI {
    
    // Get Instructors -- DONE
    static func getInstructors(complete: @escaping ( _ instructors: [User]?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/instructors"
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
                    
                    var instructors: [User] = []
                    for i in json {
                        
                        let body = i.1 // Json
                        
                        let instructor = User(json: body)
                        
                        instructors.append(instructor)
                    }
                    
                    complete(instructors, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(nil, error as NSError?)
            }
        }
    }
    
    // Get Students -- DONE
    static func getStudents(complete: @escaping ( _ students: [User]?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/students"
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
                    
                    var students: [User] = []
                    for i in json {
                        
                        let body = i.1 // Json
                        
                        let student = User(json: body)
                        
                        students.append(student)
                    }
                    
                    complete(students, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(nil, error as NSError?)
            }
        }
    }
    
    // Get Specific User -- DONE
    static func getUser(id: String, complete: @escaping ( _ user: User?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/users/\(id)"
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
                    
                    let user = User(json: json)
                    
                    complete(user, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(nil, error as NSError?)
            }
        }
    }
    
    // Get Self -- DONE
    static func getMe(complete: @escaping ( _ user: User?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/me"
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
                    
                    let user = User(json: json)
                    
                    complete(user, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(nil, error as NSError?)
            }
        }
    }
    
    // Update Self -- READY
    static func updateMe(user: User, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/me"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // MAKE SURE USER HAS ALL REQUIRED STUFF HERE??
        
        // Request the data from api
        Alamofire.request(url, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON() { response in
            
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
    
    // Login to Account -- DONE
    static func login(email: String, password: String, complete: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/auth/login"
        let url = CourseBoardAPI.baseUrl + path
        
        // Set up parameters
        let parameters = ["email": email, "password": password]
        
        // Request the data from API
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON() { response in
            
            switch response.result {
                
            // Success
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let token = json["token"].stringValue
                    CourseBoardAPI.authToken = token
                    TokenHelper.saveToken(token: token)
                    
                    // Get me
                    CourseBoardAPI.getMe(complete: { (user: User?, error: NSError?) in
                        if let user = user {
                            self.me = user
                        }
                    })
                    
                    complete(true, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(false, error as NSError?)
            }
        }
    }
    
    static func alreadyLoggedIn(complete: @escaping (_ success: Bool) -> Void) {
        
        // If no token, return
        guard let token = TokenHelper.getToken() else {
            complete(false)
            return
        }
        
        // Set auth token
        self.authToken = token
        
        getMe { (user: User?, error: NSError?) in
            
            if user == nil {
                TokenHelper.saveToken(token: nil)
                complete(false)
            }
            else {
                self.me = user
                complete(true)
            }
            
        }
        
        
    }
    
    // Signup -- DONE
    static func signup(email: String, username: String, password: String, role: String = "Student", first: String? = nil, last: String? = nil, complete: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/auth/signup"
        let url = CourseBoardAPI.baseUrl + path
        
        // Set up parameters
        var parameters = ["email": email, "username": username, "password": password, "role": role]
        
        if let first = first {
            parameters["first"] = first
        }
        if let last = last {
            parameters["last"] = last
        }
        
        // Request the data from API
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON() { response in
            
            switch response.result {
                
            // Success
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let token = json["token"].stringValue
                    CourseBoardAPI.authToken = token
                    
                    complete(true, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(false, error as NSError?)
            }
        }
    }
    
    // Request Password -- READY
    static func requestPassword(email: String, username: String, password: String, complete: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/auth/passwords"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Request the data from API
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON() { response in
            
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
    
    // Update Password -- READY
    static func updatePassword(email: String, username: String, password: String, complete: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/auth/passwords"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Request the data from API
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON() { response in
            
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
    
}
