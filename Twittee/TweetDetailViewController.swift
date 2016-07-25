//
//  TweetDetailViewController.swift
//  Twittee
//
//  Created by Do Nguyen on 7/23/16.
//  Copyright © 2016 Do Nguyen. All rights reserved.
//

import UIKit


@objc protocol TweetDetailViewControllerDelegate {
    optional func tweetDetailViewController(tweetDetailViewController: TweetDetailViewController, didChangeTweet tweet: Tweet)
}

class TweetDetailViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var item: Tweet?
    @IBOutlet weak var replyTextField: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var replyTextViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var replyViewHeightContraints: NSLayoutConstraint!
    @IBOutlet weak var replyButton: UIBarButtonItem!
    weak var delegate: TweetDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        replyTextField.layer.borderColor = UIColor(red: 176/255.0, green: 182/255.0, blue: 187/255.0, alpha: 1.0).CGColor
//        replyTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TweetDetailViewController.keyboardDidAppear(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TweetDetailViewController.keyboardDidDisappear(_:)), name: UIKeyboardDidHideNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @objc func keyboardDidAppear(notification: NSNotification) {
        if let notificationInfo  = notification.userInfo {
            let keyboardFrame = notificationInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
//            let keyboardFrame = view.convertRect(value, fromView: nil)
            
            replyViewHeightContraints.constant = keyboardFrame.height + 40
            
        }
    }
    
    @objc func keyboardDidDisappear(notification: NSNotification) {
        replyViewHeightContraints.constant = 40
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func replyButtonTouched(sender: AnyObject) {
        if let client = User.client {
            var parameters =  Dictionary<String, AnyObject>()
            let status = "@\(item!.user.screenName) \(replyTextField.text!)"
            parameters["status"] = status
            parameters["in_reply_to_status_id"] = item!.id
            client.post(API_UPDATE_STATUS_URL, parameters: parameters, success: {
                data, response in
                self.navigationController?.popViewControllerAnimated(true)

                }, failure: {(error: NSError!) -> Void in
                    self.showError(error.localizedDescription)
            })
        }
    }
}

extension TweetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TweetTableViewCell
        configureCell(cell, forRowAtIndexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func configureCell(cell: TweetTableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = .None
        
        cell.avatarImageView.hnk_setImageFromURL(NSURL(string: item!.user.profileImageUrl)!)
        cell.nameLabel.text = item!.user.name
        
        var createdTime: String?
        let time = NSDate().timeIntervalSinceDate(item!.createdAt)
        if time < 60 {
            createdTime = "\(Int(time))s"
        } else if time < 3600 {
            createdTime = "\(Int(time / 60))m"
        } else if time < 24 * 3600 {
            createdTime = "\(Int(time / 60 / 60))h"
        } else {
            createdTime = "\(Int(time / 60 / 60 / 24))d"
        }
        cell.id = item!.id
        cell.timeLabel.text = createdTime!
        cell.screenNameLabel.text = "@" + item!.user.screenName
        cell.bodyLabel.text = item!.text
        cell.retweetCountLabel.text = "\(item!.retweetCount)"
        cell.favoriteCountLabel.text = "\(item!.favouritesCount)"
        let favImage = item!.favorited ? UIImage(named: "Favorite") : UIImage(named: "Unfavorite")
        cell.favoriteButton.setImage(favImage, forState: .Normal)
        
        let retweetImage = item!.favorited ? UIImage(named: "Retweet") : UIImage(named: "Unretweet")
        cell.retweetButton.setImage(retweetImage, forState: .Normal)


    }
}

extension TweetDetailViewController: TweetTableViewCellDelegate {
    func tweetTableViewCell(tweetTableViewCell: TweetTableViewCell, didChangeFavoriteValue value: Bool, favoriteCount: Int) {
        item!.favorited = value
        item!.favouritesCount = favoriteCount
        delegate!.tweetDetailViewController!(self, didChangeTweet: item!)
    }
    
    func tweetTableViewCell(tweetTableViewCell: TweetTableViewCell, didChangeRetweetValue value: Bool, retweetCount: Int) {        
        item!.retweeted = value
        item!.retweetCount = retweetCount
        delegate!.tweetDetailViewController!(self, didChangeTweet: item!)
    }
}

extension TweetDetailViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var newText: NSString = textView.text!
        newText = newText.stringByReplacingCharactersInRange(range, withString: text)
        
        let charLeft = 140 - newText.length
        countLabel.text = "\(charLeft)"
        replyButton.enabled = charLeft > 0
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        
        let textViewFixedWidth: CGFloat = textView.frame.size.width
        let newSize: CGSize = replyTextField.sizeThatFits(CGSizeMake(textViewFixedWidth, CGFloat(MAXFLOAT)))
        var newFrame: CGRect = textView.frame
        
        //        var textViewYPosition = textView.frame.origin.y
        let heightDifference = textView.frame.height - newSize.height
        
        if (abs(heightDifference) > 20) {
            newFrame.size = CGSizeMake(fmax(newSize.width, textViewFixedWidth), newSize.height)
            newFrame.offsetInPlace(dx: 0.0, dy: 0)
        }
        textView.frame = newFrame
    }
}
