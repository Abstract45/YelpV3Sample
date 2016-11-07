//
//  BusinessModel.swift
//  YelpSamp
//
//  Created by Miwand Najafe on 2016-11-07.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import Foundation

class BusinessModel: ObjectType {
    var photoUrls: [String] = []
    var hours:String = ""
    
    required init(dictionary: Dictionary<String, Any>) {
        if let photos = dictionary["photos"] as? [String] {
            photoUrls = photos
        }
        
        if let hrs = dictionary["hours"] as? [Dictionary<String,Any>] {
            if let openHrs = hrs[0]["open"] as?  [Dictionary<String,Any>] {
                for h in openHrs {
                    
                    let start = h["start"] as! String
                    let end = h["end"] as! String
                    let day = h["day"] as! Int
                    switch day {
                    case 0:
                        hours += "Monday: \(start) - \(end) \n"
                    case 1:
                        hours += "Tuesday: \(start) - \(end) \n"
                    case 2:
                        hours += "Wednesday: \(start) - \(end) \n"
                    case 3:
                        hours += "Thursday: \(start) - \(end) \n"
                    case 4:
                        hours += "Friday: \(start) - \(end) \n"
                    case 5:
                        hours += "Saturday: \(start) - \(end) \n"
                    case 6:
                        hours += "Sunday: \(start) - \(end)"
                    default:
                        return
                    }
                }
            }
        }
    }
}
