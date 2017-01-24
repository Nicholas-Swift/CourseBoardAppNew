//
//  CourseRequestHelper.swift
//  CourseBoardAPI
//
//  Created by Nicholas Swift on 10/6/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension CourseBoardAPI {
    
    // MARK: Get Courses -- DONE
    static func getCourses(complete: @escaping ( _ courses: [Course]?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/courses"
        let url = CourseBoardAPI.baseUrl + path
        
        // Request the data from api
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON() { response in
            
            switch response.result {
                
            // Success
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    var courses: [Course] = []
                    for i in json {
                        
                        let body = i.1 // Json
                        
                        let course = Course(json: body)
                        
                        courses.append(course)
                    }
                    
                    complete(courses, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(nil, error as NSError?)
            }
        }
    }
    
    // MARK: Get Current Courses -- DONE
    static func getCurrentCourses(complete: @escaping ( _ courses: [Course]?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/current-courses"
        let url = CourseBoardAPI.baseUrl + path
        
        // Request the data from api
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON() { response in
            
            switch response.result {
                
                // Success
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        var courses: [Course] = []
                        for i in json {
                            
                            print(json)
                            let body = i.1 // Json
                            
                            let course = Course(json: body)
                            
                            courses.append(course)
                        }
                        
                        complete(courses, nil)
                    }
                
                // Failure
                case .failure(let error):
                    print("error: \(error)")
                    complete(nil, error as NSError?)
            }
        }
    }
    
    // MARK: Get Specific Course -- DONE
    static func getCourse(id: String, complete: @escaping ( _ course: Course?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/courses/\(id)"
        let url = CourseBoardAPI.baseUrl + path
        
        // Request the data from api
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON() { response in
            
            switch response.result {
                
            // Success
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let course = Course(json: json)
                    
                    complete(course, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error: \(error)")
                complete(nil, error as NSError?)
            }
        }
        
    }
    
    // MARK: Create Course -- DONE
    static func createCourse(course: Course, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/courses"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Set up parameters with course
        var parameters: [String: AnyObject] = [:]
        
        // title, description
        if let title = course.title {
            parameters["title"] = title as AnyObject?
        }
        if let description = course.description {
            parameters["description"] = description as AnyObject?
        }
        
        // quarter, weekDays, startTime, location
        if let quarter = course.quarter {
            parameters["quarter"] = quarter as AnyObject?
        }
        if let weekdays = course.weekdays {
            parameters["weekDays"] = weekdays as AnyObject?
        }
        if let startTime = course.startTime {
            parameters["startTime"] = startTime as AnyObject?
        }
        if let location = course.location {
            parameters["location"] = location as AnyObject?
        }
        
        // objectives
        if let objectives = course.objectives {
            parameters["objectives"] = objectives as AnyObject?
        }
        
        // instructor
        if let instructor = course.instructor?.id {
            parameters["instructor"] = instructor as AnyObject?
        } else {
            complete(false, NSError(domain: "No course instructor id", code: 400, userInfo: nil))
        }
        
        // Request the data from api
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON() { response in
            
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
    
    // MARK: Update Course -- READY
    static func updateCourse(course: Course, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        guard let id = course.id else {
            print("Failed ID")
            complete(false, NSError(domain: "No course id", code: 400, userInfo: nil))
            return
        }
        
        guard let instructor = course.instructor?.id else {
            complete(false, NSError(domain: "No course instructor id", code: 400, userInfo: nil))
            return
        }
        
        // Create the path and url
        let path = "/api/courses/\(id)"
        let url = CourseBoardAPI.baseUrl + path
        print(url)
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Set up parameters with course
        var parameters: [String: AnyObject] = [:]
        
        // title, description
        if let title = course.title {
            parameters["title"] = title as AnyObject?
        }
        if let description = course.description {
            parameters["description"] = description as AnyObject?
        }
        
        // quarter, weekDays, startTime, location
        if let quarter = course.quarter {
            parameters["quarter"] = quarter as AnyObject?
        }
        if let weekdays = course.weekdays {
            parameters["weekDays"] = weekdays as AnyObject?
        }
        if let startTime = course.startTime {
            parameters["startTime"] = startTime as AnyObject?
        }
        if let location = course.location {
            parameters["location"] = location as AnyObject?
        }
        
        // objectives
        if let objectives = course.objectives {
            parameters["objectives"] = objectives as AnyObject?
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
                print("error: \(error)")
                complete(false, error as NSError?)
            }
        }
    }
    
    // MARK: Delete Course -- DONE
    static func deleteCourse(id: String, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and resource
        let path = "/api/courses/\(id)"
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
    
    // MARK: Enroll Course -- DONE
    static func enrollCourse(id: String, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and resource
        let path = "/api/courses/\(id)/enroll"
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
    
    // MARK: Unenroll Course -- DONE
    static func unenrollCourse(id: String, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and resource
        let path = "/api/courses/\(id)/unenroll"
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
    
    // MARK: Publish Course -- DONE
    static func publishCourse(id: String, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and resource
        let path = "/api/courses/\(id)/publish"
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
    
    // MARK: Unpublish Course -- DONE
    static func unpublishCourse(id: String, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and resource
        let path = "/api/courses/\(id)/unpublish"
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
    
}
