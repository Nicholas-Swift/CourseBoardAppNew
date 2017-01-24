//
//  FirebaseRequestHelper.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 1/17/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

extension CourseBoardAPI {
    
    static func getPicUrl(id: String, complete: @escaping (_ url: String?, _ error: Error?) -> Void) {
        
        let picsRef = datRef.child("profilePictures/\(id)")
        
        picsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let urlString = snapshot.value as? String
            
            if urlString == "" || urlString == nil {
                complete(nil, NSError(domain: "Error", code: 404, userInfo: nil))
            }
            else {
                complete(urlString, nil)
            }
            
        }, withCancel: {
            (error) in
            complete(nil, error)
        })
        
    }
    
}
