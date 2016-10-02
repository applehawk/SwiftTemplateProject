//
//  ServiceProtocol.swift
//  StreamingTwitter
//
//  Created by Hawk on 25/09/16.
//  Copyright © 2016 Hawk. All rights reserved.
//

import Foundation

@objc protocol ServiceStreamingProtocol {
    //Async request
    func startStream( progressHandler: @escaping () -> Void, failure: (_ error: String) -> Void )
    //Getting last updated data
    func obtainData() -> AnyObject?
}
