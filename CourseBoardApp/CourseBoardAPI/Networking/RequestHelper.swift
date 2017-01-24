//
//  RequestHelper.swift
//  CourseBoardAPI
//
//  Created by Nicholas Swift on 10/6/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

class CourseBoardAPI {
    
    static var authToken = ""
    static let baseUrl = "https://meancourseboard.herokuapp.com"
    
    static var datRef = FIRDatabase.database().reference()
    static var storRef = FIRStorage.storage().reference()
    
    static var me: User?
    
    //static let baseUrl = "http://localhost:1337"
    
}
