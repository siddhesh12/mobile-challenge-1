//
//  FeatureModel.swift
//  CodingChallenge
//
//  Created by Siddhesh Mahadeshwar on 04/05/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import Foundation
import SwiftyJSON
struct FeatureModel {
    let currentPage: Int
    let photos: [Picture]?
    
    static func getFeature(rawPictures: [JSON]?, currentPage:Int) -> FeatureModel {
        return FeatureModel(currentPage: currentPage, photos: Picture.getPicturesFrom(rawArray: rawPictures))
    }
}
