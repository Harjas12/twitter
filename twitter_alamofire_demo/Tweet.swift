//
//  Tweet.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation
import DateToolsSwift

class Tweet {
    
    // MARK: Properties
    var id: Int64 // For favoriting, retweeting & replying
    var text: String // Text content of tweet
    var favoriteCount: Int? // Update favorite count label
    var favorited: Bool? // Configure favorite button
    var retweetCount: Int // Update favorite count label
    var retweeted: Bool // Configure retweet button
    var user: User // Contains name, screenname, etc. of tweet author
    var createdAtString: String // Display date
    var profileImageUrl: URL
    
    var retweetedByUser: User?
    
    // MARK: - Create initializer with dictionary
    init(dictionary: [String: Any]) {
        
        var dictionary = dictionary
        
        if let originalTweet = dictionary["retweeted_status"] as? [String: Any] {
            let userDictionary = dictionary["user"] as! [String: Any]
            self.retweetedByUser = User(dictionary: userDictionary)
            
            dictionary = originalTweet
            
        }
        
        id = dictionary["id"] as! Int64
        text = dictionary["full_text"] as! String
        favoriteCount = dictionary["favorite_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweetCount = dictionary["retweet_count"] as! Int
        retweeted = dictionary["retweeted"] as! Bool
        
        let userDictionary = dictionary["user"] as! [String: Any]
        let profileImageStringUrl = userDictionary["profile_image_url_https"] as! String
        profileImageUrl = URL(string: profileImageStringUrl)!
        
        let user = dictionary["user"] as! [String: Any]
        self.user = User(dictionary: user)
        
        let createdAtOriginalString = dictionary["created_at"] as! String
        let date: Date = Date(dateString: createdAtOriginalString, format: "E MMM d HH:mm:ss Z y")
        createdAtString = date.shortTimeAgoSinceNow
        
        let uDiction = dictionary["user"] as! [String: Any]
        self.user = User(dictionary: uDiction)
    }
    static func tweets(with array: [[String: Any]]) -> [Tweet] {
        return array.flatMap({ (dictionary) -> Tweet in
            Tweet(dictionary: dictionary)
        })
    }
    
}

