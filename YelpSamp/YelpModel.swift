//
//  YelpModel.swift
//  YelpSamp
//
//  Created by Miwand Najafe on 2016-11-06.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import Foundation

class YelpModel: NSObject, ObjectType {
    var id:String = ""
    var price: String = ""
    var name: String = ""
    var phone: String = ""
    var reviewCount:String = ""
    var coordinate: Coordinates? = nil
    var isClosed: Bool = false
    var address: Location? = nil
    var imageURLString: String = ""
    var categories: String = ""
    var rating:Double = 0.0
    var distanceMiles: String = ""
    var distanceMeters: String = ""
    
    required init(dictionary: Dictionary<String,Any>) {
        if let id = dictionary["id"] as? String {
            self.id = id
        }
        
        if let price = dictionary["price"] as? String {
            self.price = price
        }
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let phone = dictionary["phone"] as? String {
            self.phone = phone
        }
        if let isClosed = dictionary["is_closed"] as? Bool {
            self.isClosed = isClosed
        }
        if let coordinate = dictionary["coordinates"] as? Dictionary<String, Any> {
            self.coordinate = Coordinates(dictionary: coordinate)
        }
        if let location = dictionary["location"] as? Dictionary<String, Any> {
            address = Location(dictionary: location)
        }
        if let imageURL = dictionary["image_url"] as? String {
            imageURLString = imageURL
        }
        
        if let distance = dictionary["distance"] as? Double {
            self.distanceMiles = "\((distance/1609.344).rounded()) mi"
            self.distanceMeters = "\(Int(distance)) m"
        }
        
        if let categories = dictionary["categories"] as? [Dictionary<String,String>] {

            for i in 0..<categories.count {
                let cat = Category(dictionary: categories[i])
                
                if i == categories.count - 1 {
                    self.categories += cat.title
                } else {
                    self.categories += cat.title + " , "
                }
            }
        }
        if let rating = dictionary["rating"] as? Double {
            self.rating = rating
        }
        
        if let reviewCount = dictionary["review_count"] as? Int {
            self.reviewCount = String(reviewCount)
        }
    }
    override var description: String {
        return ("price: \(price), name: \(name), phone: \(phone), reviewCount \(reviewCount), coordinate: \(coordinate?.description), isClosed: \(isClosed), location: \(address?.description), imageUrlString: \(imageURLString), categories: \(categories.description), rating: \(rating.description))")
    }
}

struct Category: CustomStringConvertible, ObjectType {
    var title: String = ""
    var alias: String = ""
    var description: String
    init(dictionary: Dictionary<String, Any>) {
        if let title = dictionary["title"] as? String {
            self.title = title
        }
        if let alias = dictionary["alias"] as? String {
            self.alias = alias
        }
        description = "title: \(self.title), alias: \(alias)"
    }
}


struct Coordinates: CustomStringConvertible, ObjectType {
    var longitude:Double = 0.0
    var latitude:Double = 0.0
    var description: String
    init(dictionary: Dictionary<String, Any>) {
        if let lng = dictionary["longitude"] as? Double {
            longitude = lng
        }
        if let lat = dictionary["latitude"] as? Double {
            latitude = lat
        }
        
        description = "lat: \(latitude), lng: \(longitude)"
    }
    
}


struct Location: CustomStringConvertible, ObjectType {
    var fullAddress = ""
    var description: String
    init(dictionary: Dictionary<String, Any>) {
        
        if let address1 = dictionary["address1"] as? String {
            fullAddress.append(address1)
        }
        if let zipCode = dictionary["zip_code"] as? String {
            fullAddress.append(", " + zipCode)
        }
        if let address2 = dictionary["address2"] as? String, address2 != "" {
            fullAddress.append(", " + address2)
        }
        if let address3 = dictionary["address3"] as? String, address3 != ""  {
            fullAddress.append(", " + address3)
        }
        if let country = dictionary["country"] as? String {
            fullAddress.append(", " + country)
        }
        if let state = dictionary["state"] as? String {
            fullAddress.append(", " + state)
        }
        if let city = dictionary["city"] as? String {
            fullAddress.append(", " + city)
        }
        
        description = "address: \(fullAddress)"
    }
}
