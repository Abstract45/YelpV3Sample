//
//  MainVC.swift
//  YelpSamp
//
//  Created by Miwand Najafe on 2016-11-06.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import UIKit
import AFNetworking
import CoreLocation

class MainVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var dataObject = [YelpModel]()
    var currentlySelected: YelpModel!
    let locManager = CLLocationManager()
    var lastLocation = CLLocation(latitude: 44.6687, longitude: -93.5425)
    var currentLocation = CLLocation(latitude: 0, longitude: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.requestAlwaysAuthorization()
        setUpLocationManager()
    }
    
    func setUpLocationManager() {
        self.locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = currentLocation
        currentLocation = locations[0]
        if currentLocation.distance(from: lastLocation) > 300  {
            print("Calling API")
            if let userDefaults:AnyObject = Prefs.USER_DEFAULTS.fromPreference(),
                let defaults = userDefaults as? [String:String] {
                Constant.OAUTH_TOKEN = defaults["access_token"]!
                callYelpForDataWith(term: "restaurants", currentLocation:currentLocation.coordinate)
            } else {
                getToken(completion: {
                    callYelpForDataWith(term: "restaurants", currentLocation:currentLocation.coordinate)
                })
            }
        }
    }
    
    
    func callYelpForDataWith(term: String, currentLocation: CLLocationCoordinate2D) {
        APIClient.shared.getData(urlString: Constant.BASE_YELP_URL, term: term, currentLocation: currentLocation, completion: { [unowned self](object) in
            self.dataObject = object
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if currentLocation.coordinate.latitude != 0.0 {
        switch sender.selectedSegmentIndex {
        case 1:
            callYelpForDataWith(term: "museums", currentLocation:currentLocation.coordinate)
        case 2:
            callYelpForDataWith(term: "hotels", currentLocation:currentLocation.coordinate)
        case 3:
            callYelpForDataWith(term: "localflavor", currentLocation:currentLocation.coordinate)
        default:
            callYelpForDataWith(term: "restaurants", currentLocation:currentLocation.coordinate)
        }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.FROM_MAIN_TO_DETAIL {
            if let destainationVC = segue.destination as? DetailView {
                destainationVC.yelpData = currentlySelected
            }
        }
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentlySelected = dataObject[indexPath.row]
        performSegue(withIdentifier: Segues.FROM_MAIN_TO_DETAIL, sender: self)
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCells.YELPCELL, for: indexPath) as? YelpCell else { return UITableViewCell() }
        cell.configCell(with: dataObject[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObject.count
    }
}


