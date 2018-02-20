//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet] = []
    let refreshControl = UIRefreshControl()
    var maxID: Int64 = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.insertSubview(refreshControl, at: 0)
        
        refreshControl.addTarget(self, action: #selector(getNewTweets), for: UIControlEvents.valueChanged)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInformation(loadNew: true)
    }
    func getNewTweets() {
        getInformation(loadNew: true)
    }
    func getInformation(loadNew: Bool) {
        if loadNew {
             maxID = -1
        }
        APIManager.shared.getHomeTimeLine(maxId: maxID, completion: { (tweets, error) in
            if let tweets = tweets {
                if loadNew {
                    self.tweets = tweets
                } else {
                    self.tweets.append(contentsOf: tweets)
                }
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        })
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tweets.count - 1 {
            if tweets.count > 0 {
                var lowestTweetID: Int64 = tweets[0].id
                for tweet in tweets {
                    if tweet.id < lowestTweetID {
                        lowestTweetID = tweet.id
                    }
                }
                maxID = lowestTweetID - 1
                getInformation(loadNew: false)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let destination = segue.destination as! TweetDetailViewController
            let cell = sender as! TweetCell
            destination.tweet = cell.tweet
        }
    }
}
