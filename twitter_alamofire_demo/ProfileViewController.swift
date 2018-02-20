//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Harjas Monga on 2/19/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var numOfTweetsLabel: UILabel!
    @IBOutlet weak var numOfFollowingLabel: UILabel!
    @IBOutlet weak var numOfFollowersLabel: UILabel!
    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = User.current {
            profileImageView.af_setImage(withURL: user.profileImageUrl)
            taglineLabel.text = user.tagline
            numOfTweetsLabel.text = "\(String(user.tweetCount)) tweets"
            numOfFollowersLabel.text = "\(String(user.followers)) followers"
            numOfFollowingLabel.text = "\(String(user.following)) following"
            if let url = user.profileBackgroundUrl {
                profileBackgroundImageView.af_setImage(withURL: url)
            }
            nameLabel.text = user.name
            screenNameLabel.text = "@\(user.screenName)"
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
            profileImageView.clipsToBounds = true
        }
    }
}
