//
//  MainScreenDDM.swift
//  SwiftTemplateProject
//
//  Created by Hawk on 28/09/16.
//  Copyright © 2016 Hawk. All rights reserved.
//

import UIKit.UITableView

//Display Data Manager

protocol MainScreenDDMProtocol : UITableViewDelegate, UITableViewDataSource {
    var rowSelectedDelegate : MainScreenDelegate? { get set }
}

class MainScreenDDM : NSObject, MainScreenDDMProtocol {
    var service : ServiceStreamingProtocol!
    var rowSelectedDelegate : MainScreenDelegate?
    
    enum ErrorKind : Error {
        case AccessNotPossibleByIndex
        case NotTweetsArray
        case PrototypeCellNotCreated
    }
    
    init(twitterService: ServiceStreamingProtocol) {
        self.service = twitterService
        
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = rowSelectedDelegate else {
            return
        }
        let tweets : [Tweet?] = service.obtainData() as! [Tweet?]
        do {
            guard let tweet = tweets[indexPath.row] else {
                throw ErrorKind.AccessNotPossibleByIndex
            }
            delegate.didSelectedTweet(tweet: tweet)
        } catch ErrorKind.AccessNotPossibleByIndex {
            print("Access to tweets not possible by index: \(indexPath.row), tweets count: \(tweets.count)")
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let lastIdx = service.lastIndex()
        let bufferSize = service.bufferSize()
        return lastIdx < bufferSize ? lastIdx : bufferSize
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweets = service.obtainData() as? [Tweet]
        let indexTweet = (service.lastIndex() + indexPath.row) % service.bufferSize()
        
        if let tweet = tweets?[indexTweet] {
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TweetCell.self),
                for: indexPath) as? TweetCell
            {
                cell.configureForModel(indexPath: indexPath, tweet: tweet)
                return cell
            }
        }
        return UITableViewCell()
    }
}
