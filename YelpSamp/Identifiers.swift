//
//  Identifiers.swift
//  YelpSamp
//
//  Created by Miwand Najafe on 2016-11-06.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import Foundation

struct Constant {
    static let CLIENT_ID = "qZnvYCTw7otKFVjjYoWMtQ"
    static let CLIENT_SECRET = "6N77YGPnInBUdq4vfeI612KLDLnP84Kutw9o9zczuXW9fQpcUxYpszlsQbH27Dhs"
    static let BASE_YELP_URL = "https://api.yelp.com/v3/businesses/search"
    static var OAUTH_TOKEN = ""
    static var OAUTHDEFAULTS: [String:Any] = [:]
}

struct Prefs {
    static let USER_DEFAULTS = "User Defaults"
}

struct ReusableCells {
    static let YELPCELL = "Custom Cell made for yelp"
    static let DETAILCELL = "Detail Cell made for business details"
}

struct Segues {
    static let FROM_MAIN_TO_DETAIL = "Seguing from main to detail view"
}

extension String {
    func saveAsPreference<T: NSObject>(object: [T]) {
        // self is bridged to NSString
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(data, forKey: self)
    }
    
    func saveAsPreference<T:AnyObject>(object: T) {
        // self is bridged to NSString
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(data, forKey: self)
    }
    
    func fromPreference<T>() -> T? {
        guard let data = UserDefaults.standard.object(forKey: self) as? Data else { return nil }
        guard let unarchivedData = NSKeyedUnarchiver.unarchiveObject(with: data) as? T else { print("Could not convert Data to Pokedots"); return nil }
        return unarchivedData
    }
}
