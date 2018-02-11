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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTweetTextView.delegate = self
        newTweetTextView.becomeFirstResponder()
        characterCountLabel.textColor = UIColor.green
    }
    func textViewDidChange(_ textView: UITextView) {
        let characterCount = newTweetTextView.text.count
        characterCountLabel.text = "\(characterCount)/280"
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
            APIManager.shared.sendTweet(newTweetTextView.text) { (tweet: Tweet?, error: Error?) in
                if tweet != nil  {
                    print("tweet sent succesfully")
                    self.dismiss(animated: true, completion: nil)
                } else if error != nil  {
                    print("tweet failed to send")
                }
            }
        }
    }
}
