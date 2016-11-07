//
//  ReviewModel.swift
//  YelpSamp
//
//  Created by Miwand Najafe on 2016-11-07.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import Foundation

class ReviewModel: ObjectType {
    var rating: String = ""
    var username: String = ""
    var text:String = ""
    var userImageString:String = ""

    
    required init(dictionary: Dictionary<String, Any>) {
        if let rating = dictionary["rating"] as? Double {
            self.rating = String(rating)
        }
        if let user = dictionary["user"] as? Dictionary<String,Any>,
            let username = user["name"] as? String {
            self.username = username
            if let img = user["image_url"] as? String {
                userImageString = img
            }
        }
        if let txt = dictionary["text"] as? String {
            text = txt
        }
    }
}
