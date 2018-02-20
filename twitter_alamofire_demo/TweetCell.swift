//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import ActiveLabel

class TweetCell: UITableViewCell {
    

    @IBOutlet weak var tweetTextLabel: ActiveLabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweenButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var retweeCountLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    let hapticFeedback = UIImpactFeedbackGenerator()
    
    var tweet: Tweet! {
        didSet {
            resetCellValues()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        tweetTextLabel.enabledTypes = [.mention, .hashtag, .url]
        tweetTextLabel.URLColor = UIColor.twitterBlueColor()
        tweetTextLabel.mentionColor = UIColor.twitterBlueColor()
        tweetTextLabel.hashtagColor = UIColor.twitterBlueColor()
        tweetTextLabel.handleURLTap { (url: URL) in
            UIApplication.shared.open(url)
        }
        tweetTextLabel.urlMaximumLength = 30
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
    func resetCellValues() {
        tweetTextLabel.text = tweet.text
        profileImageView.af_setImage(withURL: tweet.profileImageUrl)
        nameLabel.text = tweet.user.name
        screenLabel.text = "@" + tweet.user.screenName
        let likeButtonImage: UIImage
        if tweet.favorited! {
            likeButtonImage = UIImage(named: "favor-icon-red")!
        } else {
            likeButtonImage = UIImage(named: "favor-icon")!
        }
        likeButton.setImage(likeButtonImage, for: UIControlState.normal)
        let retweetButtonImage: UIImage
        if tweet!.retweeted {
            retweetButtonImage = UIImage(named: "retweet-icon-green")!
        } else {
            retweetButtonImage = UIImage(named: "retweet-icon")!
        }
        retweenButton.setImage(retweetButtonImage, for: UIControlState.normal)
        likeCountLabel.text = String(tweet.favoriteCount!)
        retweeCountLabel.text = String(tweet.retweetCount)
        timeAgoLabel.text = "\(tweet.createdAtString) ago"
    }
    @IBAction func likeButtonPressed(_ sender: Any) {
        hapticFeedback.impactOccurred()
        if tweet.favorited! {
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                    self.tweet = tweet
                }
            }
        } else {
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                    self.tweet = tweet
                }
            }
        }
    }
    @IBAction func retweenButtonPressed(_ sender: Any) {
        hapticFeedback.impactOccurred()
        if tweet.retweeted {
            APIManager.shared.undoRetweet(tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("error unretweeting tweet: \(error.localizedDescription)")
                } else {
                    print("Sucessfully unretweeted the following Tweet: \n\(tweet!.text))")
                    self.tweet = tweet
                }
            })
        } else {
            APIManager.shared.retweet(tweet, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("error retweeting tweet: \(error.localizedDescription)")
                } else {
                    print("Sucessfully retweeted the following Tweet: \n\(tweet!.text))")
                    self.tweet = tweet
                }
            })
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
