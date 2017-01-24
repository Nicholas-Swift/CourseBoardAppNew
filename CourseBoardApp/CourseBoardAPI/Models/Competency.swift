//
//  Competency.swift
//  CourseBoardAPI
//
//  Created by Nicholas Swift on 10/4/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import SwiftyJSON

class Competency {
    
    var id: String?
    
    var createdAt: Date?
    var updatedAt: Date?
    
    var name: String?
    var level: Int?
    var kind: String?
    var note: String?
    
    var instructor: User?
    
    init() {
        
    }
    
    init(json: JSON) {
        
        // id
        if let id = json["_id"].string {
            self.id = id
        }
        
        // createdAt, updatedAt
        if let createdAt = json["createdAt"].string {
            self.createdAt = DateHelper.toDate(stringDate: createdAt)
        }
        if let updatedAt = json["updatedAt"].string {
            self.updatedAt = DateHelper.toDate(stringDate: updatedAt)
        }
        
        // name, level, kind, note
        if let name = json["name"].string {
            self.name = name
        }
        if let level = json["level"].int {
            self.level = level
        }
        if let kind = json["kind"].string {
            self.kind = kind
        }
        if let note = json["note"].string {
            self.note = note
        }
        
        // instructor
        if let instructor = json["instructor"].string {
            self.instructor = User()
            self.instructor?.id = instructor
        }
        else if json["instructor"].dictionary != nil {
            self.instructor = User(json: json["instructor"])
        }
        
    }
    
}
