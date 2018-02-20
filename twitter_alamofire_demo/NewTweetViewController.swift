//
//  NewTweetViewController.swift
//  twitter_alamofire_demo
//
//  Created by Harjas Monga on 2/10/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var newTweetTextView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    var replyTo: String?
    var replyToId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTweetTextView.delegate = self
        newTweetTextView.becomeFirstResponder()
        characterCountLabel.textColor = UIColor.green
        if let replyTo = replyTo {
            newTweetTextView.text = replyTo
        }
        textViewDidChange(newTweetTextView)
    }
    func textViewDidChange(_ textView: UITextView) {
        let characterCount = newTweetTextView.text.count
        characterCountLabel.text = "\(280 - characterCount)"
        if characterCount > 280 {
            characterCountLabel.textColor = UIColor.red
        } else {
            characterCountLabel.textColor = UIColor.green
        }
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tweetButtonPressed(_ sender: Any) {
        let characterCount = newTweetTextView.text.count
        if characterCount > 0 && characterCount <= 280  {
            if let replyId = replyToId {
                APIManager.shared.sendTweet(isReply: true, replyId: replyId, newTweetTextView.text) { (tweet: Tweet?, error: Error?) in
                    if tweet != nil  {
                        print("tweet sent succesfully")
                        self.view.endEditing(true)
                        self.dismiss(animated: true, completion: nil)
                    } else if error != nil  {
                        print("tweet failed to send")
                    }
                }
            } else {
                APIManager.shared.sendTweet(isReply: false, replyId: nil, newTweetTextView.text) { (tweet: Tweet?, error: Error?) in
                    if tweet != nil  {
                        print("tweet sent succesfully")
                        self.view.endEditing(true)
                        self.dismiss(animated: true, completion: nil)
                    } else if error != nil  {
                        print("tweet failed to send")
                    }
                }
            }
        }
    }
}
