//
//  Constants.swift
//  Twittee
//
//  Created by Do Nguyen on 7/22/16.
//  Copyright © 2016 Do Nguyen. All rights reserved.
//

import UIKit

// MARK: - Screen constants
let SCREEN_SIZE = UIScreen.mainScreen().bounds.size
let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
let NAV_BAR_FONT = "Avenir-Light"
let MAIN_FONT = "Avenir-Next"

// MARK: - Colors
let MAIN_COLOR = UIColor(red: 80/255.0, green: 199/255.0, blue: 229/255.0, alpha: 1.0)
let SECONDARY_COLOR = UIColor(red: 39/255.0, green: 179/255.0, blue: 236/255.0, alpha: 1.0)
let BORDER_COLOR = UIColor.darkGrayColor()

let NAV_COLOR = UIColor(red: 80/255.0, green: 199/255.0, blue: 229/255.0, alpha: 1.0)

// MARK: - API
let API_KEY = "kjdVuu51ehZ8rHl5iJ5tm5ydC"
let API_SECRET = "KzKJBwWr0YAyvAXExSuMUhMmfD1mP3hwfEvGb25sso7LaVXXH5"
let API_REQUEST_TOKEN_URL = "https://api.twitter.com/oauth/request_token"
let API_AUTHORIZE_URL = "https://api.twitter.com/oauth/authorize"
let API_ACCESS_TOKEN_URL = "https://api.twitter.com/oauth/access_token"
let API_BASE_URL = "https://api.twitter.com/1.1"
let API_HOME_URL = API_BASE_URL + "/statuses/home_timeline.json"
let API_FAV_URL = API_BASE_URL + "/favorites/create.json"
let API_UNFAV_URL = API_BASE_URL + "/favorites/destroy.json"
let API_RETWEET_URL = API_BASE_URL + "/statuses/retweet/"
let API_UNRETWEET_URL = API_BASE_URL + "/statuses/unretweet/"
let API_UPDATE_STATUS_URL = API_BASE_URL + "/statuses/update.json"
