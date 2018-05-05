//
//  ApiManager.swift
//  CodingChallenge
//
//  Created by Siddhesh Mahadeshwar on 04/05/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Result<T> {
    case Success(T)
    case Failure(String)
}

let consumerKey = "e7TNbI12TOBude6ESgVqFu3y060Rw09pi0wpbF41"
let images = "/v1/photos"
let Schema = "https"
#if DEVELOPMENT
let HOST = "api.500pxDev.com"
#elseif QA
let HOST = "api.500pxQA.com"
#else
let HOST = "api.500px.com"
#endif
let serverURL = Schema+"://"+HOST

class APIManager: NSObject{
    
     static let shared = APIManager()
    
//    private override init() {
//        super.init()
//        let configuration = URLSessionConfiguration.default
//        configuration.httpMaximumConnectionsPerHost = 10
//        configuration.timeoutIntervalForRequest = 30
//        configuration.timeoutIntervalForResource =  30
//    }
    
    func getPhotos(currentPage:Int, completionHandler: @escaping (Result<FeatureModel>) -> Void){
        
        let parameters: [String: String] = ["consumer_key": consumerKey, "page": "\(currentPage + 1)", "image_size":"2048"]
        
        Alamofire.request(serverURL+images, parameters: parameters).validate().responseJSON { (responseObject) in
            
            switch responseObject.result {
            case .success(let value):
                let json = JSON(value)
                
                guard let pictures = json["photos"].array, let currentPage = json["current_page"].int else {
                    completionHandler(Result.Failure("Data is missing")); return
                }
                
                completionHandler(Result.Success(FeatureModel.getFeature(rawPictures: pictures, currentPage: currentPage)))

            case .failure(let error):
                completionHandler(Result.Failure(error.localizedDescription))
            }
        }
    }
}
