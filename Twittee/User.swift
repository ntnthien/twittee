//
//  User.swift
//  Twittee
//
//  Created by Do Nguyen on 7/22/16.
//  Copyright © 2016 Do Nguyen. All rights reserved.
//

import Foundation
import OAuthSwift

class User {
    let description: String
    let favouritesCount: Int
    let followersCount: Int
    let following: Bool
    let friendsCount: Int
    let id: Int
    let location: String
    let name: String
    let profileBackgroundColor: String
    let profileBackgroundImageUrl: String
    let profileImageUrl: String
    let profileUseBackgroundImage: Bool
    let screenName: String
    let statusesCount: Int
    let url: String?
    let verified: Bool
    
    static private var _client: OAuthSwiftClient!
    
    init?(_ info: [String: AnyObject]) {
        guard let description = info["description"] as? String else { return nil }
        guard let favouritesCount = info["favourites_count"] as? Int else { return nil }
        guard let followersCount = info["followers_count"] as? Int else { return nil }
        guard let following = info["following"] as? Bool else { return nil }
        guard let friendsCount = info["friends_count"] as? Int else { return nil }
        guard let id = info["id"] as? Int else { return nil }
        guard let location = info["location"] as? String else { return nil }
        guard let name = info["name"] as? String else { return nil }
        guard let profileBackgroundColor = info["profile_background_color"] as? String else { return nil }
        guard let profileBackgroundImageUrl = info["profile_background_image_url_https"] as? String else { return nil }
        guard let profileImageUrl = info["profile_image_url_https"] as? String else { return nil }
        guard let profileUseBackgroundImage = info["profile_use_background_image"] as? Bool else { return nil }
        guard let screenName = info["screen_name"] as? String else { return nil }
        guard let statusesCount = info["statuses_count"] as? Int else { return nil }
        guard let verified = info["verified"] as? Bool else { return nil }

        self.description = description
        self.favouritesCount = favouritesCount
        self.followersCount = followersCount
        self.following = following
        self.friendsCount = friendsCount
        self.id = id
        self.location = location
        self.name = name
        self.profileBackgroundColor = profileBackgroundColor
        self.profileBackgroundImageUrl = profileBackgroundImageUrl
        self.profileImageUrl = profileImageUrl
        self.profileUseBackgroundImage = profileUseBackgroundImage
        self.screenName = screenName
        self.statusesCount = statusesCount
        if let url = info["url"] as? String {
            self.url = url
        } else {
            self.url = nil
        }

        self.verified = verified
    }
    
    static var client: OAuthSwiftClient? {
        get {
            if _client != nil {
                return _client
            }
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            
            if let accessToken = userDefaults.stringForKey("accessToken"), accessTokenSecret = userDefaults.stringForKey("accessTokenSecret") {
                _client = OAuthSwiftClient(
                    consumerKey: API_KEY,
                    consumerSecret: API_SECRET,
                    accessToken: accessToken,
                    accessTokenSecret: accessTokenSecret
                )
                
                return _client
            }
            
            return nil
        }
        set {
            let userCredential = ["accessToken": newValue!.credential.oauth_token, "accessTokenSecret": newValue!.credential.oauth_token_secret]
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            for(key, data) in userCredential {
                if data != "" {
                    userDefaults.setObject(data, forKey: key)
                }
            }
            
            _client = client
        }
    }
    
    static func logout() {
        _client = nil
        for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        }
    }
    
  
}
