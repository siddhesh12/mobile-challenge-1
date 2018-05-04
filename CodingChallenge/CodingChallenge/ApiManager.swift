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
}
