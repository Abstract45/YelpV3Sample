//
//  DetailView.swift
//  YelpSamp
//
//  Created by Miwand Najafe on 2016-11-06.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import UIKit

class DetailView: UIViewController {

    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var hoursOperationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placePhoneLabel: UILabel!
    @IBOutlet weak var placeRating: UIImageView!
    var yelpData: YelpModel!
    @IBOutlet weak var detailTable: UITableView!
    var reviews = [ReviewModel]()
    var bDetail: BusinessModel?
    
    var isHoursHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(infoAction(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        APIClient.shared.getBusinessDetails(id: yelpData.id, completion: { [unowned self](bDetail, reviews) in
            self.reviews = reviews
            self.bDetail = bDetail
            self.refreshTable()
            
        })
    }
    @IBAction func infoAction(_ sender: UIButton) {
        isHoursHidden = !isHoursHidden
        hoursOperationLabel.isHidden = isHoursHidden
    }

    func refreshTable() {
        DispatchQueue.main.async {
            self.configView()
            self.detailTable.reloadData()
        }
    }
    
    
    func configView() {
        if let address = yelpData.address {
            addressLabel.text = address.fullAddress
        }
        placeNameLabel.text = yelpData.name
        placePhoneLabel.text = "# " + yelpData.phone
        let imageName = "rating" + String(yelpData.rating)
        placeRating.image = UIImage(named: imageName)
        if bDetail?.hours != nil {
            if bDetail!.photoUrls.count > 0 {
                mainImg.setImageWith(URL(string: bDetail!.photoUrls[0])!)
            }
            hoursOperationLabel.text = bDetail?.hours
        }
    }
}

extension DetailView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height:CGFloat = self.calculateHeightForString(inString: reviews[indexPath.row].text)
        return height + 70.0
    }

    func calculateHeightForString(inString:String) -> CGFloat
    {
        let messageString = inString
        let attributes = [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 11.0)]
        let attrString:NSAttributedString? = NSAttributedString(string: messageString, attributes: attributes)
        let rect:CGRect = attrString!.boundingRect(with: CGSize(width: 300.0,height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context:nil )//hear u will get nearer height not the exact value
        let requredSize:CGRect = rect
        return requredSize.height  //to include button's in your tableview
    }
}
extension DetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCells.DETAILCELL) as! ReviewCell
        cell.configView(model: reviews[indexPath.row])
            
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
}
