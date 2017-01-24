//
//  Update.swift
//  CourseBoardAPI
//
//  Created by Nicholas Swift on 10/4/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import SwiftyJSON

class Update {
    
    var id: String?
    
    var createdAt: Date?
    var updatedAt: Date?
    
    var body: String?
    var kind: String?
    
    var user: User?
    var product: Product?
    
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
        
        // body, kind
        if let body = json["body"].string {
            self.body = body
        }
        if let kind = json["kind"].string {
            self.kind = kind
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
        if let product = json["product"].string {
            self.product = Product()
            self.product?.id = product
        }
        else if json["product"].dictionary != nil {
            self.product = Product(json: json["product"])
        }
        
    }
}
