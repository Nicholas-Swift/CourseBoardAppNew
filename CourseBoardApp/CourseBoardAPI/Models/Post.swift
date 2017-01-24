//
//  Post.swift
//  CourseBoardAPI
//
//  Created by Nicholas Swift on 10/4/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import SwiftyJSON

class Post {
    
    var id: String?
    
    var createdAt: Date?
    var updatedAt: Date?
    var dueDate: Date?
    
    var body: String?
    var emailParticipants: Bool = false
    //var kind: String?
    
    var user: User?
    var course: Course?
    //var comments: Comment?
    
    init() {
        
    }
    
    init(json: JSON) {
        
        // id
        if let id = json["_id"].string {
            self.id = id
        }
        
        // createdAt, updatedAt, dueDate
        if let createdAt = json["createdAt"].string {
            self.createdAt = DateHelper.toDate(stringDate: createdAt)
        }
        if let updatedAt = json["updatedAt"].string {
            self.updatedAt = DateHelper.toDate(stringDate: updatedAt)
        }
        if let dueDate = json["dueDate"].string {
            self.dueDate = DateHelper.toDate(stringDate: dueDate)
        }
        
        // body, emailParticipants
        if let body = json["body"].string {
            self.body = body
        }
        if let emailParticipants = json["emailParticipants"].bool {
            self.emailParticipants = emailParticipants
        }
        
        // user
        if let user = json["user"].string {
            self.user = User()
            self.user?.id = user
        }
        else if json["user"].dictionary != nil {
            self.user = User(json: json["user"])
        }
        
        // course
        if let course = json["course"].string {
            self.course = Course()
            self.course?.id = course
        }
        else if json["course"].dictionary != nil {
            self.course = Course(json: json["course"])
        }
    }
    
}
