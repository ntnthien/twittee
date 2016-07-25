//
//  NewTweetViewController.swift
//  Twittee
//
//  Created by Do Nguyen on 7/23/16.
//  Copyright © 2016 Do Nguyen. All rights reserved.
//

import UIKit
import Haneke

class NewTweetViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var postButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusTextView.becomeFirstResponder()
        statusTextView.delegate = self
        statusTextView.layer.borderColor = UIColor(red: 176/255.0, green: 182/255.0, blue: 187/255.0, alpha: 1.0).CGColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let client = User.client {
            client.get("https://api.twitter.com/1.1/account/verify_credentials.json", success: { (data, response) in
                let json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as! [String: AnyObject]
                if let user = User(json) {
                    self.nameLabel.hidden = false
                    self.screenNameLabel.hidden = false
                    self.nameLabel.text = user.name
                    self.screenNameLabel.text = "@" + user.screenName
                    self.avatarImageView.hnk_setImageFromURL(NSURL(string: user.profileImageUrl)!)
                }
                }, failure: { (error) in
                    print(error)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButtonTouched(sender: AnyObject) {
        statusTextView.resignFirstResponder()
        if let statusMessage = statusTextView.text {
            if let client = User.client {
                let parameters = ["status": statusMessage]
                client.post(API_UPDATE_STATUS_URL, parameters: parameters, success: {
                    data, response in
                    
                    }, failure: {(error: NSError!) -> Void in
                        print(error.localizedDescription)
                })
                
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelButtonTouched(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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

extension NewTweetViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var newText: NSString = textView.text!
        newText = newText.stringByReplacingCharactersInRange(range, withString: text)
        
        let charLeft = 140 - newText.length
        countLabel.text = "\(charLeft)"
        postButton.enabled = charLeft > 0
        
        return true
    }
}