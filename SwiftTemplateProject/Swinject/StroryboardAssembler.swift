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
        defaultContainer.registerForStoryboard(MainScreenVC.self, name: "MainScreen") { r, c in
            c.mainScreenDDM = r.resolve(MainScreenDDM.self)
        }
        
        defaultContainer.register(TwitterDataSource.self) { r in
            let dataSource = TwitterDataSource()
            return dataSource
        }
        
        defaultContainer.register(MainScreenDDM.self) { r in
            let mainScreenDDM = MainScreenDDM(
                dataSource : r.resolve(TwitterDataSource.self) as! TableDataSource,
                delegate   : r.resolve(MainScreenVC.self) as! MainScreenDelegate
            )
            return mainScreenDDM
        }
    }
}
