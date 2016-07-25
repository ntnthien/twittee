//
//  LoginViewController.swift
//  Twittee
//
//  Created by Do Nguyen on 7/22/16.
//  Copyright © 2016 Do Nguyen. All rights reserved.
//

import UIKit
import OAuthSwift

class LoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTouched(sender: AnyObject) {
        let oauthswift = OAuth1Swift(
            consumerKey: API_KEY,
            consumerSecret: API_SECRET,
            requestTokenUrl: API_REQUEST_TOKEN_URL,
            authorizeUrl:    API_AUTHORIZE_URL,
            accessTokenUrl:  API_ACCESS_TOKEN_URL
        )
        
        oauthswift.authorizeWithCallbackURL(NSURL(string: "twittee://oauth-callback/")!, success: {
            credential, response in
            User.client = oauthswift.client
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeNC = storyboard.instantiateViewControllerWithIdentifier("HomeNC")
            self.presentViewController(homeNC, animated: true, completion: nil)
            

            }, failure: {(error: NSError!) -> Void in
                self.showError("Fail", message: error.localizedDescription)
            }
        )
        
        

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
