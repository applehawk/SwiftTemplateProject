//
//  TwitterStreamingService.swift
//  StreamingTwitter
//
//  Created by Hawk on 25/09/16.
//  Copyright © 2016 Hawk. All rights reserved.
//

import Foundation
import SwifteriOS

class TwitterStreamingService: NSObject, ServiceStreamingProtocol {
    
    let serialQueue = DispatchQueue(label: "tweetsSerialQueue")
    var swifter : Swifter?
    
    static let maximumTweets : Int = 5
    var tweetsIndex : Int = 0
    var tweets : [Tweet?] = Array<Tweet?>(repeating: nil, count: TwitterStreamingService.maximumTweets)
    
    enum TwitterServiceError : Error {
        case InfoPlistUnavailable
        case TokenError
        case ConsumerKeyError
        case SwifterNotInitialized
    }
    override init() {
        do {
            guard let plistTwitter = PListFile(plistFileNameInBundle: "AppConfig")?.plist?["Twitter"] else {
                throw TwitterServiceError.InfoPlistUnavailable
            }
            
            guard let STConsumerKey = plistTwitter["Consumer Key"].string,
                let STConsumerSecret = plistTwitter["Consumer Secret"].string else {
                throw TwitterServiceError.ConsumerKeyError
            }
            
            guard let STAccessToken = plistTwitter["Access Token"].string,
                let STAccessTokenSecret = plistTwitter["Access Token Secret"].string else {
                throw TwitterServiceError.TokenError
            }
            
            self.swifter = Swifter(consumerKey: STConsumerKey,
                                       consumerSecret: STConsumerSecret,
                                       oauthToken: STAccessToken,
                                       oauthTokenSecret: STAccessTokenSecret)
            if(self.swifter == nil) {
                throw TwitterServiceError.SwifterNotInitialized
            }
            
        } catch TwitterServiceError.InfoPlistUnavailable {
            print("Twitter Plist Unavailable, please check it again")
        } catch TwitterServiceError.SwifterNotInitialized {
            print("Swifter not initialized")
        } catch TwitterServiceError.ConsumerKeyError {
            print("Consumer key isn't available, please check it")
        } catch TwitterServiceError.TokenError {
            print("Token key isn't available, please check it")
        } catch {
            print(error)
        }
        super.init()
    }
    
    func progressData( result : JSON ) {
        let tweet = Tweet(text : result["text"].string)
        if let text = tweet.text {
            print("Result: \(text)")
        }
        self.tweets[self.tweetsIndex % TwitterStreamingService.maximumTweets] = tweet
        //We doing it to show how many elements already there are in buffer
        tweetsIndex += 1
        if(tweetsIndex == Int.max) {
            tweetsIndex = TwitterStreamingService.maximumTweets
        }
    }
    func lastIndex() -> Int {
        return self.tweetsIndex
    }
    func bufferSize() -> Int {
        return TwitterStreamingService.maximumTweets
    }
    func startStream( progressHandler: @escaping () -> Void, failure: (_ error: String) -> Void ) {
        _ = swifter?.postTweetFilters(track: ["london"],
            progress: { (result:JSON) in
                DispatchQueue.main.async {
                    self.progressData(result: result)
                }
                progressHandler()
            }, stallWarningHandler: { (code, message, percentFull) in
                print("postTweetFilte rs: stallWarningHandler \(code) \(message)")
            }, failure: { (error) in
                print("postTweetFilters: Failure \(error)")
            }
        );
    }
    
    func obtainData() -> AnyObject? {
        return self.tweets as AnyObject?
    }
}
