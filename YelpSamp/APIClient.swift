//
//  APIClient.swift
//  YelpSamp
//
//  Created by Miwand Najafe on 2016-11-06.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import Foundation
import CoreLocation

class APIClient {
    static let shared = APIClient()
    private init() {}
    
    func getBusinessDetails(id:String, completion: @escaping (_ businessDetails: BusinessModel,_ reviews:[ReviewModel]) -> ()) {
        self.getBusinessData(id: id, completion: { (bDetail) in
            self.getBusinessReviews(id: id, completion: { (reviews) in
                completion(bDetail,reviews)
            })
        })
    }
    
    
    private func getBusinessData(id: String, completion: @escaping (BusinessModel) -> ()) {
        let urlString = "https://api.yelp.com/v3/businesses/\(id)"
        guard let url = URL(string: urlString) else { fatalError() }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer " + Constant.OAUTH_TOKEN, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
                    let model = BusinessModel(dictionary: json)
                    completion(model)
                } catch let err {
                    print(err.localizedDescription)
                }
            }
            
        }).resume()
    }
    
    private func getBusinessReviews(id: String, completion: @escaping ([ReviewModel]) -> () ) {
        
        let urlString = "https://api.yelp.com/v3/businesses/\(id)/reviews"
        guard let url = URL(string: urlString) else { fatalError() }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer " + Constant.OAUTH_TOKEN, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
                    
                    let jsonDict = json["reviews"] as! [Dictionary<String,Any>]
                    var reviewModel = [ReviewModel]()
                    for j in jsonDict {
                        let model = ReviewModel(dictionary: j)
                        reviewModel.append(model)
                    }
                    completion(reviewModel)
                } catch let err {
                    print(err.localizedDescription)
                }
            }
            
        }).resume()
    }
    
    func getData(urlString: String, term: String,currentLocation: CLLocationCoordinate2D, completion:@escaping ([YelpModel])->()){
        var dataToSend = [YelpModel]()
        let urlStr = urlString + "?term=\(term)&latitude=\(currentLocation.latitude)&longitude=\(currentLocation.longitude)"
        guard let url = URL(string: urlStr) else { fatalError()  }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer " + Constant.OAUTH_TOKEN, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil {
                 print(error?.localizedDescription)
                if error?._code == 401 {
                    getToken {
                        
                        self.getData(urlString: Constant.BASE_YELP_URL, term: term, currentLocation: currentLocation, completion: { (yelpData) in
                            completion(yelpData)
                        })
                    }
                }
            }
            
            guard let data = data else { return }
            do {
                
                guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String,Any> else { fatalError() }
                
                guard let json = jsonDict["businesses"] as? [Dictionary<String,Any>] else { fatalError() }
                for j in json {
                    let model = YelpModel(dictionary: j)
                    dataToSend.append(model)
                }
                completion(dataToSend)
            } catch let err {
                print(err.localizedDescription)
            }
            
        }).resume()
    }
    
}

protocol ObjectType {
    init(dictionary: Dictionary<String, Any>)
}

func getToken(completion: () -> ()) {
    let url = URL(string: "https://api.yelp.com/oauth2/token")!
    
    let parameters = "grant_type=OAuth2&client_id=qZnvYCTw7otKFVjjYoWMtQ&client_secret=6N77YGPnInBUdq4vfeI612KLDLnP84Kutw9o9zczuXW9fQpcUxYpszlsQbH27Dhs"
    let data = parameters.data(using: String.Encoding.ascii, allowLossyConversion: true)
    let length = "\(data?.count)"
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(length, forHTTPHeaderField: "Content-Length")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpBody = data
    
    let tokenData = try! NSURLConnection.sendSynchronousRequest(request, returning: nil)
    
    let oAuthDict = try! JSONSerialization.jsonObject(with: tokenData, options: .allowFragments) as! NSDictionary
    Constant.OAUTH_TOKEN =  oAuthDict["access_token"] as! String
    let dict = ["access_token": Constant.OAUTH_TOKEN]
    Constant.OAUTHDEFAULTS = dict
    Prefs.USER_DEFAULTS.saveAsPreference(object: dict as AnyObject)
    completion()
}
