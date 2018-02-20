//
//  TweetDetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Harjas Monga on 2/19/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import ActiveLabel

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var tweetLabel: ActiveLabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabek: UILabel!
    @IBOutlet weak var retweenButton: UIButton!
    @IBOutlet weak var retweenCount: UILabel!
    
    var nibAwake = false
    var tweet: Tweet?{
        didSet {
            if nibAwake {
                loadTweet()
            }
        }
    }
    let hapticFeedback = UIImpactFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibAwake = true
        loadTweet()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        tweetLabel.enabledTypes = [.mention, .hashtag, .url]
        tweetLabel.URLColor = UIColor.twitterBlueColor()
        tweetLabel.mentionColor = UIColor.twitterBlueColor()
        tweetLabel.hashtagColor = UIColor.twitterBlueColor()
        tweetLabel.handleURLTap { (url: URL) in
            UIApplication.shared.open(url)
        }
        tweetLabel.urlMaximumLength = 30
    }
    func loadTweet() {
        if let tweet = tweet {
            tweetLabel.text = tweet.text
            profileImageView.af_setImage(withURL: tweet.profileImageUrl)
            nameLabel.text = tweet.user.name
            screenNameLabel.text = "@" + tweet.user.screenName
            let likeButtonImage: UIImage
            if tweet.favorited! {
                likeButtonImage = UIImage(named: "favor-icon-red")!
            } else {
                likeButtonImage = UIImage(named: "favor-icon")!
            }
            likeButton.setImage(likeButtonImage, for: UIControlState.normal)
            let retweetButtonImage: UIImage
            if tweet.retweeted {
                retweetButtonImage = UIImage(named: "retweet-icon-green")!
            } else {
                retweetButtonImage = UIImage(named: "retweet-icon")!
            }
            retweenButton.setImage(retweetButtonImage, for: UIControlState.normal)
            likeCountLabek.text = String(tweet.favoriteCount!)
            retweenCount.text = String(tweet.retweetCount)
            timeAgoLabel.text = "\(tweet.createdAtString) ago"
        }
    }
    @IBAction func likeButtonPressed(_ sender: Any) {
        hapticFeedback.impactOccurred()
        if (tweet?.favorited!)! {
            APIManager.shared.unfavorite(tweet!) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                    self.tweet = tweet
                }
            }
        } else {
            APIManager.shared.favorite(tweet!) { (tweet: Tweet?, error: Error?) in
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
        if (tweet?.retweeted)! {
            APIManager.shared.undoRetweet(tweet!, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("error unretweeting tweet: \(error.localizedDescription)")
                } else {
                    print("Sucessfully unretweeted the following Tweet: \n\(tweet!.text))")
                    self.tweet = tweet
                }
            })
        } else {
            APIManager.shared.retweet(tweet!, completion: { (tweet: Tweet?, error: Error?) in
                if let error = error {
                    print("error retweeting tweet: \(error.localizedDescription)")
                } else {
                    print("Sucessfully retweeted the following Tweet: \n\(tweet!.text))")
                    self.tweet = tweet
                }
            })
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newTweetNavigationController = segue.destination as! UINavigationController
        let newTweetController = newTweetNavigationController.viewControllers[0] as! NewTweetViewController
        if let tweet = tweet {
            newTweetController.replyToId = String(tweet.id)
            newTweetController.replyTo = "@\(tweet.user.screenName)"
        }
    }
}
