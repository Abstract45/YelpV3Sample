//
//  YelpCell.swift
//  YelpSamp
//
//  Created by Miwand Najafe on 2016-11-06.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import UIKit

class YelpCell: UITableViewCell {
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantPrice: UILabel!
    @IBOutlet weak var restaurantRating: UIImageView!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantIsClosed: UILabel!
    @IBOutlet weak var restaurantCategories: UILabel!
    @IBOutlet weak var restaurantDistance: UILabel!
    @IBOutlet weak var restaurantReviewCount: UILabel!
    func configCell(with model: YelpModel) {
        restaurantName.text = model.name
        restaurantPrice.text = model.price
        let imageName = "rating" + String(model.rating)
        restaurantRating.image = UIImage(named: imageName)
        let url = URL(string: model.imageURLString)!
        restaurantImage.setImageWith(url, placeholderImage: UIImage(named:"default"))
        restaurantIsClosed.text = model.isClosed == true ? "Closed":"Open"
        
        
        restaurantCategories.text = model.categories
        restaurantDistance.text = model.distanceMiles
        restaurantReviewCount.text = "\(model.reviewCount) reviews"
    }
}
