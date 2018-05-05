//
//  Picture.swift
//  CodingChallenge
//
//  Created by Siddhesh Mahadeshwar on 04/05/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Picture {
    let id: Int
    let imageUrl: String
    let width: Float?
    let height: Float?
    var description: String?
    var fullName: String?
    var likesCount:Int
    var commentsCount:Int
    var userProfilePicUrl: String?

     static func getPicturesFrom(rawArray: [JSON]?) -> [Picture] {
        
        var pictures =  [Picture]()
        guard let rawArray = rawArray else {
            return pictures
        }
        
        for rawDictionary in rawArray
            {
                if let dictionary = rawDictionary.dictionary, let id = dictionary["id"]?.int, let url = dictionary["image_url"]?.array?.first?.string {
                    pictures.append(Picture(id: id, imageUrl: url,
                                            width: dictionary["width"]?.float,
                                            height: dictionary["height"]?.float,
                                            description: dictionary["description"]?.string,
                                            fullName: dictionary["user"]?["fullname"].string,
                                            likesCount:dictionary["positive_votes_count"]?.int ?? 0,
                                            commentsCount:dictionary["comments_count"]?.int ?? 0,
                                            userProfilePicUrl:dictionary["user"]?["avatars"]["default"]["https"].string))
                }
            }
        
        return pictures
    }

}
