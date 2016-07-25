//
//  Tweet.swift
//  Twittee
//
//  Created by Do Nguyen on 7/22/16.
//  Copyright © 2016 Do Nguyen. All rights reserved.
//

import Foundation
import OAuthSwift

class Tweet: NSObject {
    let id: Int
    var createdAt: NSDate
    var retweetCount: Int
    var retweeted: Bool
    var source: String
    var text: String
    var user: User
    var favouritesCount: Int
    var favorited: Bool
    
    init?(_ info: [String: AnyObject]) {
        guard let id = info["id"] as? Int else { return nil }
        guard let createdAt = info["created_at"] as? String else { return nil }
        guard let favorited = info["favorited"] as? Bool else { return nil }
        guard let retweetCount = info["retweet_count"] as? Int else { return nil }
        guard let retweeted = info["retweeted"] as? Bool else { return nil }
        guard let source = info["source"] as? String else { return nil }
        guard let text = info["text"] as? String else { return nil }
        guard let userJSONDictionary = info["user"] as? [String: AnyObject] else { return nil }
        guard let user = User(userJSONDictionary) else { return nil }
        
        self.id = id
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        self.createdAt = formatter.dateFromString(createdAt)!
        if let favouriteCount = info["favorite_count"] as? Int {
            self.favouritesCount = favouriteCount
        } else {
            self.favouritesCount = 0
        }
        self.favorited = favorited
        self.retweetCount = retweetCount
        self.retweeted = retweeted
        self.source = source
        self.text = text
        self.user = user
    }
}
