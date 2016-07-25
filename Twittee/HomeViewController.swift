//
//  HomeViewController.swift
//  Twittee
//
//  Created by Do Nguyen on 7/22/16.
//  Copyright © 2016 Do Nguyen. All rights reserved.
//

import UIKit
import Haneke

class HomeViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var items: [Tweet] = []
    var refreshControl = UIRefreshControl()


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension

        refreshControl.addTarget(self, action: #selector(HomeViewController.loadData), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)

        loadData()
        
    }
    
    func loadData() {
        if let client = User.client {
            let parameters =  Dictionary<String, AnyObject>()
            client.get(API_HOME_URL, parameters: parameters, success: {
                data, response in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    let json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    for object in json {
                        let tweet = Tweet(object as! [String : AnyObject])
                        self.items.append(tweet!)
                    }
                    self.refreshControl.endRefreshing()

                    self.tableView.reloadData()
                }
                }, failure: {(error: NSError!) -> Void in
                    self.showError(error.localizedDescription)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signoutButtonTouched(sender: AnyObject) {
        User.logout()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginVC")
        self.presentViewController(vc, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TweetTableViewCell
        configureCell(cell, forRowAtIndexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func configureCell(cell: TweetTableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = .None
        let item = items[indexPath.row]
        
        cell.avatarImageView.hnk_setImageFromURL(NSURL(string: item.user.profileImageUrl)!)
        cell.nameLabel.text = item.user.name
        
        var createdTime: String?
        let time = NSDate().timeIntervalSinceDate(item.createdAt)
        if time < 60 {
            createdTime = "\(Int(time))s"
        } else if time < 3600 {
            createdTime = "\(Int(time / 60))m"
        } else if time < 24 * 3600 {
            createdTime = "\(Int(time / 60 / 60))h"
        } else {
            createdTime = "\(Int(time / 60 / 60 / 24))d"
        }
        cell.id = item.id
        cell.timeLabel.text = createdTime!
        cell.screenNameLabel.text = "@" + item.user.screenName
        cell.bodyLabel.text = item.text
        cell.retweetCountLabel.text = "\(item.retweetCount)"
        cell.favoriteCountLabel.text = "\(item.favouritesCount)"
        let favImage = item.favorited ? UIImage(named: "Favorite") : UIImage(named: "Unfavorite")
        cell.favoriteButton.setImage(favImage, forState: .Normal)
        
        let retweetImage = item.favorited ? UIImage(named: "Retweet") : UIImage(named: "Unretweet")
        cell.retweetButton.setImage(retweetImage, forState: .Normal)
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTweetDetail" {
            let tweetDetailVC = segue.destinationViewController as! TweetDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let item = items[indexPath.row]
            tweetDetailVC.item = item
            tweetDetailVC.delegate = self
            //        } else if segue.identifier == "showNewTweet" {
            //            let newTweetVC: NewTweetViewController = segue.destinationViewController as! NewTweetViewController
            //            newTweetVC.delegate = self
//        } else if segue.identifier == "showNewTweet" {
//            let newTweetNC = segue.destinationViewController as! UINavigationController
//            let newTweetVC = newTweetNC.topViewController as! NewTweetViewController
        }
    }
}

extension HomeViewController: TweetTableViewCellDelegate {
    func tweetTableViewCell(tweetTableViewCell: TweetTableViewCell, didChangeFavoriteValue value: Bool, favoriteCount: Int) {
        let indexPath = tableView.indexPathForCell(tweetTableViewCell)!

        items[indexPath.row].favorited = value
        items[indexPath.row].favouritesCount = favoriteCount
    }
    
    func tweetTableViewCell(tweetTableViewCell: TweetTableViewCell, didChangeRetweetValue value: Bool, retweetCount: Int) {
        let indexPath = tableView.indexPathForCell(tweetTableViewCell)!
        
        items[indexPath.row].retweeted = value
        items[indexPath.row].retweetCount = retweetCount
    }
}

extension HomeViewController: TweetDetailViewControllerDelegate {
    func tweetDetailViewController(tweetDetailViewController: TweetDetailViewController, didChangeTweet tweet: Tweet) {
        if let indexPath = tableView.indexPathForSelectedRow {
            items[indexPath.row] = tweet
            tableView.reloadData()
        }
    }
}
