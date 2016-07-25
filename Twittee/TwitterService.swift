//
//  TwitterService.swift
//  Twittee
//
//  Created by Do Nguyen on 7/24/16.
//  Copyright © 2016 Do Nguyen. All rights reserved.
//

import UIKit
import OAuthSwift

class TwitterService {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    class var sharedInstance: TwitterService {
        struct Static {
            static let instance = TwitterService()
        }
        return Static.instance
    }
    
    let oauthClient = OAuth1Swift(
        consumerKey: API_KEY,
        consumerSecret: API_SECRET,
        requestTokenUrl: API_REQUEST_TOKEN_URL,
        authorizeUrl:    API_AUTHORIZE_URL,
        accessTokenUrl:  API_ACCESS_TOKEN_URL
    )
    
    func login(successCompletion: (credential: OAuthSwiftCredential?, response: NSURLResponse?) -> (), failureCompletion: (error: NSError!) -> ()) {
        oauthClient.authorizeWithCallbackURL(NSURL(string: "twittee://oauth-callback/")!, success: successCompletion, failure: failureCompletion)
    }
    
    
}
