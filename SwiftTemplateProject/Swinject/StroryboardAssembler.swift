//
//  StroryboardAssembler.swift
//  SwiftTemplateProject
//
//  Created by Hawk on 30/09/16.
//  Copyright © 2016 Hawk. All rights reserved.
//

import Foundation

import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        defaultContainer.registerForStoryboard(MainScreenVC.self) { r, c in
            c.mainScreenDDM = r.resolve(MainScreenDDM.self)
            c.twitterService = r.resolve(TwitterStreamingService.self)
        }
        
        defaultContainer.register(TwitterStreamingService.self) { r in
            let twitterService = TwitterStreamingService()
            return twitterService
        }.inObjectScope(.container)
        
        defaultContainer.register(MainScreenDDM.self) { r in
            
            let mainScreenDDM = MainScreenDDM(
                twitterService : r.resolve(TwitterStreamingService.self)!
            )
            return mainScreenDDM
        }.inObjectScope(.graph)
    }
}
