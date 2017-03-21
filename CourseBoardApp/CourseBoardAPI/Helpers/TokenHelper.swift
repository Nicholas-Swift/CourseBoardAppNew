//
//  TokenHelper.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 1/26/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import Foundation

class TokenHelper {
    
    static func getToken() -> String? {
        let token = UserDefaults.standard.string(forKey: "token")
        return token
    }
    
    static func saveToken(token: String?) {
        UserDefaults.standard.set(token, forKey: "token")
    }
    
}
