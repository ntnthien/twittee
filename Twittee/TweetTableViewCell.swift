//
//  TweetTableViewCell.swift
//  Twittee
//
//  Created by Do Nguyen on 7/22/16.
//  Copyright © 2016 Do Nguyen. All rights reserved.
//

import UIKit

enum ButtonState {
    case On
    case Off
}

@objc protocol TweetTableViewCellDelegate {
    optional func tweetTableViewCell(tweetTableViewCell: TweetTableViewCell, didChangeFavoriteValue value: Bool, favoriteCount: Int)
    optional func tweetTableViewCell(tweetTableViewCell: TweetTableViewCell, didChangeRetweetValue value: Bool, retweetCount: Int)
}


class TweetTableViewCell: UITableViewCell {
    var id: Int!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!

    weak var delegate: TweetTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func shareButtonTouched(sender: AnyObject) {
    }
    
    @IBAction func retweetButtonTouched(sender: AnyObject) {
        let retweetAction: ButtonState = retweetButton.imageView?.image == UIImage(named: "Unretweet") ? .On : .Off
        
        if let client = User.client {
            var url = retweetAction == .On ? API_RETWEET_URL : API_UNRETWEET_URL
            url += "\(id).json"
            let parameters =  ["id": id]
            client.post(url, parameters: parameters, success: {
                data, response in
                var retweetCount = Int(self.retweetCountLabel.text!)!
                
                retweetCount = retweetAction == .On ? retweetCount + 1 : retweetCount - 1
                self.retweetCountLabel.text = "\(retweetCount)"
                let favImage = retweetAction == .On ? UIImage(named: "Retweet") : UIImage(named: "Unretweet")
                self.retweetButton.setImage(favImage, forState: .Normal)
                self.delegate?.tweetTableViewCell?(self, didChangeRetweetValue: retweetAction == .On ? true : false, retweetCount: retweetCount)
                
                }, failure: {(error: NSError!) -> Void in
                    print(error.localizedDescription)
            })
        }
    }
    
    
   
    @IBAction func favoriteButtonTouched(sender: AnyObject) {
        let favoriteAction: ButtonState = favoriteButton.imageView?.image == UIImage(named: "Unfavorite") ? .On : .Off
        
        if let client = User.client {
            let url = favoriteAction == .On ? API_FAV_URL : API_UNFAV_URL
            let parameters =  ["id": id]
            client.post(url, parameters: parameters, success: {
                data, response in
                var favoriteCount = Int(self.favoriteCountLabel.text!)!
                
                favoriteCount = favoriteAction == .On ? favoriteCount + 1 : favoriteCount - 1
                self.favoriteCountLabel.text = "\(favoriteCount)"
                let favImage = favoriteAction == .On ? UIImage(named: "Favorite") : UIImage(named: "Unfavorite")
                self.favoriteButton.setImage(favImage, forState: .Normal)
                self.delegate?.tweetTableViewCell!(self, didChangeFavoriteValue: favoriteAction == .On ? true : false, favoriteCount: favoriteCount)
                }, failure: {(error: NSError!) -> Void in
                    print(error.localizedDescription)
            })
            
        }

    }
    
    
}
