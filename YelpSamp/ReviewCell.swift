//
//  ReviewCell.swift
//  YelpSamp
//
//  Created by Miwand Najafe on 2016-11-07.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userMessageLabel:UILabel!
    @IBOutlet weak var userImage:UIImageView!
    @IBOutlet weak var userRatingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configView(model: ReviewModel) {
        usernameLabel.text = model.username
        userMessageLabel.text = model.text
        let imageName = "rating" + String(model.rating)
        userRatingImage.image = UIImage(named: imageName)
        if let imageURL = URL(string:model.userImageString) {
            userImage.setImageWith(imageURL, placeholderImage: UIImage(named: "user"))
        }
    }
    
}
