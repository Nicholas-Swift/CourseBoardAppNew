//
//  Product.swift
//  CourseBoardAPI
//
//  Created by Nicholas Swift on 10/4/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import SwiftyJSON

class Product {
    
    var id: String?
    
    var createdAt: Date?
    var updatedAt: Date?
    
    var name: String?
    var githubUrl: String?
    var agileUrl: String?
    var liveUrl: String?
    
    var problem: String?
    var assumptions: String?
    var finishedProduct: String?
    var mvp: String?
    
    var marketFit: Int?
    var nps: Int?
    
    var customer: String?
    var valueProposition: String?
    var channels: String?
    var customerRelationships: String?
    var revenueStreams: String?
    var keyActivities: String?
    var keyResources: String?
    var keyPartners: String?
    var costStructure: String?
    
    var course: Course?
    var instructor: User?
    var contributors: [User]?
    var updates: [Update]?
    
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
        
        // name, githubUrl, agileUrl, liveUrl
        if let name = json["name"].string {
            self.name = name
        }
        if let githubUrl = json["githubUrl"].string {
            self.githubUrl = githubUrl
        }
        if let agileUrl = json["agileUrl"].string {
            self.agileUrl = agileUrl
        }
        if let liveUrl = json["liveUrl"].string {
            self.liveUrl = liveUrl
        }
        
        // problem, customer, assumptions, finishedProduct, mvp
        if let problem = json["problem"].string {
            self.problem = problem
        }
        if let assumptions = json["assumptions"].string {
            self.assumptions = assumptions
        }
        if let finishedProduct = json["finishedProduct"].string {
            self.finishedProduct = finishedProduct
        }
        if let mvp = json["mvp"].string {
            self.mvp = mvp
        }
        
        // marketFit, nps
        if let marketFit = json["marketFit"].int {
            self.marketFit = marketFit
        }
        if let nps = json["nps"].int {
            self.nps = nps
        }
        
        // customer, valueProposition, channels, customerRelationships, revenueStreams, keyActivities, keyResources, keyPartners, costStructure
        if let customer = json["customer"].string {
            self.customer = customer
        }
        if let valueProposition = json["valueProposition"].string {
            self.valueProposition = valueProposition
        }
        if let channels = json["channels"].string {
            self.channels = channels
        }
        if let customerRelationships = json["customerRelationships"].string {
            self.customerRelationships = customerRelationships
        }
        if let revenueStreams = json["revenueStreams"].string {
            self.revenueStreams = revenueStreams
        }
        if let keyActivities = json["keyActivities"].string {
            self.keyActivities = keyActivities
        }
        if let keyResources = json["keyResources"].string {
            self.keyResources = keyResources
        }
        if let keyPartners = json["keyPartners"].string {
            self.keyPartners = keyPartners
        }
        if let costStructure = json["costStructure"].string {
            self.costStructure = costStructure
        }
        
        // course
        if let course = json["course"].string {
            self.course = Course()
            self.course?.id = course
        }
        else if json["course"].dictionary != nil {
            self.course = Course(json: json["course"])
        }
        
        // instructor
        if let instructor = json["instructor"].string {
            self.instructor = User()
            self.instructor?.id = instructor
        }
        else if json["instructor"].dictionary != nil {
            self.instructor = User(json: json["instructor"])
        }
        
        // contributors
        if let contributors = json["contributors"].array {
            self.contributors = []
            if contributors.count > 0 {
                if let id = contributors[0].string {
                    for _ in 0..<contributors.count {
                        let contributor = User()
                        contributor.id = id
                        self.contributors?.append(contributor)
                    }
                }
                else if contributors[0].dictionary != nil {
                    for i in 0..<contributors.count {
                        let contributor = User(json: json["contributors"][i])
                        self.contributors?.append(contributor)
                    }
                }
            }
        }
        
        // updates
        if let updates = json["updates"].array {
            self.updates = []
            if updates.count > 0 {
                if let id = updates[0].string {
                    for _ in 0..<updates.count {
                        let update = Update()
                        update.id = id
                        self.updates?.append(update)
                    }
                }
                else if updates[0].dictionary != nil {
                    for i in 0..<updates.count {
                        let update = Update(json: json["updates"][i])
                        self.updates?.append(update)
                    }
                }
            }
        }
        
    }
    
}
