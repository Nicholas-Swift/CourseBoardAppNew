//
//  User.swift
//  CourseBoardAPI
//
//  Created by Nicholas Swift on 10/4/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import SwiftyJSON
import AlamofireImage

class User {
    
    // Variables
    var id: String?
    
    var createdAt: Date?
    var updatedAt: Date?
    var confirmedAt: Date?
    
    var email: String?
    var password: String?
    
    var first: String?
    var last: String?
    var fullname: String?
    var username: String?
    
    var role: String?
    var admin: Bool? = false
    
    var courses: [Course]?
    var enrolledCourses: [Course]?
    var products: [Product]?
    var competencies: [Competency]?
    
    // User Image helper
    let tempImageView: UIImageView = UIImageView()
    static var picsDict: [String: UIImage] = [:]
    var profilePic: UIImage?
    
    lazy var totalAmount: Float = { [unowned self] in
        let bool = self.admin
        
        if bool == false {
            return 0
        }
        else {
            return 1
        }
        
    }()
    
    init() {
        
    }
    
    init(json: JSON) {
        
        // id
        if let id = json["_id"].string {
            self.id = id
        }
        
        // createdAt, updatedAt, confirmedAt
        if let createdAt = json["createdAt"].string {
            self.createdAt = DateHelper.toDate(stringDate: createdAt)
        }
        if let updatedAt = json["updatedAt"].string {
            self.updatedAt = DateHelper.toDate(stringDate: updatedAt)
        }
        if let confirmedAt = json["confirmedAt"].string {
            self.confirmedAt = DateHelper.toDate(stringDate: confirmedAt)
        }
        
        // email password
        if let email = json["email"].string {
            self.email = email
        }
        if let password = json["password"].string {
            self.password = password
        }
        
        // first, last, fullname, username
        if let first = json["first"].string {
            self.first = first
        }
        if let last = json["last"].string {
            self.last = last
        }
        if let fullname = json["fullname"].string {
            self.fullname = fullname
        }
        if let username = json["username"].string {
            self.username = username
        }
            
        // role, admin
        if let role = json["role"].string {
            self.role = role
        }
        if let admin = json["admin"].bool {
            self.admin = admin
        }
        
        // courses
        if let courses = json["courses"].array {
            self.courses = []
            if courses.count > 0 {
                if let id = courses[0].string {
                    for _ in 0..<courses.count {
                        let course = Course()
                        course.id = id
                        self.courses?.append(course)
                    }
                }
                else if courses[0].dictionary != nil {
                    for i in 0..<courses.count {
                        let course = Course(json: json["courses"][i])
                        self.courses?.append(course)
                    }
                }
            }
        }
        
        // enrolledCourses
        if let enrolledCourses = json["enrolledCourses"].array {
            self.enrolledCourses = []
            if enrolledCourses.count > 0 {
                if let id = enrolledCourses[0].string {
                    for _ in 0..<enrolledCourses.count {
                        let enrolledCourse = Course()
                        enrolledCourse.id = id
                        self.enrolledCourses?.append(enrolledCourse)
                    }
                }
                else if enrolledCourses[0].dictionary != nil {
                    for i in 0..<enrolledCourses.count {
                        let enrolledCourse = Course(json: json["enrolledCourses"][i])
                        self.enrolledCourses?.append(enrolledCourse)
                    }
                }
            }
        }
        
        // products
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
                else if products[0].dictionary != nil {
                    for i in 0..<products.count {
                        let product = Product(json: json["products"][i])
                        self.products?.append(product)
                    }
                }
            }
        }
        
        // competencies
        if let competencies = json["competencies"].array {
            self.competencies = []
            if competencies.count > 0 {
                if let id = competencies[0].string {
                    for _ in 0..<competencies.count {
                        let competency = Competency()
                        competency.id = id
                        self.competencies?.append(competency)
                    }
                }
                else if competencies[0].dictionary != nil {
                    for i in 0..<competencies.count {
                        let competency = Competency(json: json["competencies"][i])
                        self.competencies?.append(competency)
                    }
                }
            }
        }
        
        // Load image
        
        if let value = User.picsDict[self.id!] {
            profilePic = value
            return
        }
        
        CourseBoardAPI.getPicUrl(id: self.id!) { [weak self] (url: String?, error: Error?) in
            // make sure can load url
            guard let url = url else {
                return // error
            }
            let realUrl = URL(string: url)!
            self?.profilePic = nil
            
            self?.tempImageView.af_setImage(withURL: realUrl, completion: { response in
                guard let data = response.data else {
                    return // error
                }
                
                let image = UIImage(data: data)
                self?.profilePic = image
                
                if let s = self {
                    User.picsDict[s.id!] = image
                }
            })
        }
    }
    
}
