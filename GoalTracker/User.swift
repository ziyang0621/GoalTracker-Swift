//
//  User.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/19/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

class User: NSObject {
    var dictionary: NSDictionary
    var userId: String?
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var followerCount: Int?
    var followingCount: Int?
    var statusesCount: Int?
    var profileBannerUrl: String?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        userId = dictionary["id"] as? String
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["descrption"] as? String
        followerCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        statusesCount = dictionary["statuses_count"] as? Int
        profileBannerUrl = dictionary["profile_banner_url"] as? String
    }
}
