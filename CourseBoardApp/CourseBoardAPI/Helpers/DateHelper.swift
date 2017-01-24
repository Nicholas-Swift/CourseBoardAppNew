//
//  DateHelper.swift
//  CourseBoardAPI
//
//  Created by Nicholas Swift on 10/15/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import Foundation

class DateHelper {
    
    static let monthDict = [1: "Jan", 2: "Feb", 3: "Mar", 4: "Apr", 5: "May", 6: "Jun", 7: "Jul", 8: "Aug", 9: "Sep", 10: "Oct", 11: "Nov", 12: "Dec"]
    
    static func toDate(stringDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: stringDate) as Date?
        
        return(date)
    }
    
    static func toLabelText(date: Date) -> String {
        
        var currentString = "Created on "
        
        let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
        
        // Month
        currentString += "\(monthDict[components.month ?? 1]!) "
        
        // Day
        currentString += "\(components.day ?? 1)"
        if components.day == 1 {
            currentString += "st, "
        }
        else if components.day == 2 {
            currentString += "nd, "
        }
        else if components.day == 3 {
            currentString += "rd, "
        }
        else {
            currentString += "th, "
        }
        
        // Year
        currentString += "\(components.year ?? 2001)"
        
        return currentString
    }
    
}
