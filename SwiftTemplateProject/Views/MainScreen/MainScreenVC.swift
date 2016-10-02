//
//  MainScreenVC.swift
//  SwiftTemplateProject
//
//  Created by Hawk on 28/09/16.
//  Copyright © 2016 Hawk. All rights reserved.
//

import UIKit

class MainScreenVC: UIViewController, MainScreenDelegate {
    //Injected by DI
    var mainScreenDDM : MainScreenDDMProtocol!
    var twitterService : ServiceStreamingProtocol!
    
    //Injected by Storyboard
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Custom Views of ViewController
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    // MARK: - STMainScreenDelegate methods
    func didSelectedTweet(tweet: Tweet) {
        if let text = tweet.text {
            self.presentAlertMessageVC(title: "Tweet message", message: text, settingsButton: false, buttonTitle: "OK")
        }
    }
    // MARK: - ViewController methods
    override func viewWillAppear(_ animated: Bool) {
        tableView.separatorStyle = .none
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Self-sizing rows, it's works only on iOS 8 and later
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UIScreen.main.bounds.height / 8.0
        
        tableView.delegate = mainScreenDDM
        tableView.dataSource = mainScreenDDM
        
        mainScreenDDM.rowSelectedDelegate = self
        
        let tweetCellNib = UINib(nibName: String(describing: TweetCell.self),
                                      bundle: nil)
        tableView.register(tweetCellNib,
                           forCellReuseIdentifier: String(describing: TweetCell.self))
        
        twitterService.startStream(progressHandler: {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
                
                print("Progress ...")
            }
        }, failure: { errorString in
            DispatchQueue.main.async {
                self.presentAlertMessageVC(title: "Failure request to StreamingAPI", message: errorString, settingsButton: false, buttonTitle: "OK")
            }
        })
    }
}

