//
//  PostRequestHelper.swift
//  CourseBoardAPI
//
//  Created by Nicholas Swift on 10/23/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension CourseBoardAPI {
    
    // Posts from enrolled courses - DONE
    static func getPostsFromEnrolledCourses(userId: String, complete: @escaping ( _ posts: [Post]?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/users/\(userId)/posts"
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
                    
                    var posts: [Post] = []
                    for i in json {
                        
                        let body = i.1 // Json
                        
                        let post = Post(json: body)
                        
                        posts.append(post)
                    }
                    
                    complete(posts, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error:")
                print(error)
                complete(nil, error as NSError?)
            }
        }
    }
    
    // Posts from a single course -- DONE
    static func getPostsFromCourse(courseId: String, complete: @escaping ( _ posts: [Post]?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/courses/\(courseId)/posts"
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
                    
                    var posts: [Post] = []
                    for i in json {
                        
                        let body = i.1 // Json
                        
                        let post = Post(json: body)
                        
                        posts.append(post)
                    }
                    
                    complete(posts, nil)
                }
                
            // Failure
            case .failure(let error):
                print("error:")
                print(error)
                complete(nil, error as NSError?)
            }
        }
    }
    
    // MARK: Create Post -- DONE
    static func createPost(courseId: String, post: Post, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/courses/\(courseId)/posts"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Set up parameters with course
        var parameters: [String: AnyObject] = [:]
        
        if let user = post.user?.id {
            parameters["user"] = user as AnyObject
        } else {
            complete(false, NSError(domain: "Invalid user id", code: 400, userInfo: nil))
        }
        
        parameters["course"] = courseId as AnyObject
        
        if let body = post.body {
            parameters["body"] = body as AnyObject?
        } else {
            complete(false, NSError(domain: "Post has no body -> very lonely", code: 400, userInfo: nil))
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
    
    // MARK: Update Post -- READY
    static func updatePost(postId: String, post: Post, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/posts/\(postId)"
        let url = CourseBoardAPI.baseUrl + path
        
        // Headers
        let headers = ["Authorization": "Basic " + CourseBoardAPI.authToken]
        
        // Set up parameters with course
        var parameters: [String: AnyObject] = [:]
        
        if let user = post.user?.id {
            parameters["user"] = user as AnyObject
        } else {
            complete(false, NSError(domain: "Invalid user id", code: 400, userInfo: nil))
        }

        if let body = post.body {
            parameters["body"] = body as AnyObject?
        } else {
            complete(false, NSError(domain: "Post has no body -> very lonely", code: 400, userInfo: nil))
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
    
    // MARK: Delete Post -- DONE
    static func deletePost(courseId: String, postId: String, complete: @escaping ( _ bool: Bool?, _ error: NSError?) -> Void) {
        
        // Create the path and url
        let path = "/api/courses/\(courseId)/posts/\(postId)"
        let url = CourseBoardAPI.baseUrl + path
        
        print("URL: \(url)")
        
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
