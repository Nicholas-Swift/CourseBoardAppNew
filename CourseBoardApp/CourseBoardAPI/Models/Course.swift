//
//  Course.swift
//  CourseBoardAPI
//
//  Created by Nicholas Swift on 10/4/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import SwiftyJSON

class Course {
    
    // Variables
    var id: String?
    
    var createdAt: Date?
    var updatedAt: Date?
    var publishedAt: Date?
    
    var title: String?
    var description: String?
    
    var quarter: String?
    var weekdays: String?
    var startTime: String?
    var location: String?
    
    //var startsOn: Date?
    //var startsOnDay: String?
    //var startsOnMonth: String?
    //var startsOnYear: String?
    
    //var endsOn: Date?
    //var endsOnDay: String?
    //var endsOnMonth: String?
    //var endsOnYear: String?
    
    var objectives: [String]?
    
    var user: User?
    var instructor: User?
    var students: [User]?
    var posts: [Post]?
    var products: [Product]?
    
    // Init
    
    init() {
        
    }
    
    
    init(json: JSON) {
        
        // id
        if let id = json["_id"].string {
            self.id = id
        }
        
        // createdAt, updatedAt, publishedAt, quarter
        if let createdAt = json["createdAt"].string {
            self.createdAt = DateHelper.toDate(stringDate: createdAt)
        }
        if let updatedAt = json["updatedAt"].string {
            self.updatedAt = DateHelper.toDate(stringDate: updatedAt)
        }
        if let publishedAt = json["publishedAt"].string {
            self.publishedAt = DateHelper.toDate(stringDate: publishedAt)
        }
        
        // title, description
        if let title = json["title"].string {
            self.title = title
        }
        if let description = json["description"].string {
            self.description = description
        }
        
        // quarter, weekDays, startTime, location
        if let quarter = json["quarter"].string {
            self.quarter = quarter
        }
        if let weekdays = json["weekDays"].string {
            self.weekdays = weekdays
        }
        if let startTime = json["startTime"].string {
            self.startTime = startTime
        }
        if let location = json["location"].string {
            self.location = location
        }
        
        // objectives
        if let objectives = json["objectives"].array {
            self.objectives = objectives.map{$0.stringValue}
        }
        
        // user
        if let user = json["user"].string {
            self.user = User()
            self.user?.id = user
        }
        else if json["user"].dictionary != nil {
            self.user = User(json: json["user"])
        }
        
        // instructor
        if let instructor = json["instructor"].string {
            self.instructor = User()
            self.instructor?.id = instructor
        }
        else if json["instructor"].dictionary != nil {
            self.instructor = User(json: json["instructor"])
        }
        
        //students
        if let students = json["students"].array {
            self.students = []
            if students.count > 0 {
                if let id = students[0].string {
                    for _ in 0..<students.count {
                        let student = User()
                        student.id = id
                        self.students?.append(student)
                    }
                }
                else if students[0].dictionary != nil {
                    for i in 0..<students.count {
                        let student = User(json: json["students"][i])
                        self.students?.append(student)
                    }
                }
            }
        }
        
        //posts
        if let posts = json["posts"].array {
            self.posts = []
            if posts.count > 0 {
                if let id = posts[0].string {
                    for _ in 0..<posts.count {
                        let post = Post()
                        post.id = id
                        self.posts?.append(post)
                    }
                }
                else if let _ = posts[0].dictionary {
                    for i in 0..<posts.count {
                        let post = Post(json: json["posts"][i])
                        self.posts?.append(post)
                    }
                }
            }
        }
        
        //products
        if let products = json["products"].array {
            self.products = []
            if products.count > 0 {
                if let id = products[0].string {
                    for _ in 0..<products.count {
                        let product = Product()
                        product.id = id
                        self.products?.append(product)
                    }
                }
                else if let _ = products[0].dictionary {
                    for i in 0..<products.count {
                        let product = Product(json: json["products"][i])
                        self.products?.append(product)
                    }
                }
            }
        }
        
    }
    
}

