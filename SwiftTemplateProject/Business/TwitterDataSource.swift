//
//  MainScreenDataSource.swift
//  SwiftTemplateProject
//
//  Created by Hawk on 29/09/16.
//  Copyright © 2016 Hawk. All rights reserved.
//

import CoreGraphics.CGBase
import SwifteriOS

protocol TableDataSource {
    var sectionsCount : Int { get }
    var rowsCountBySection : [Int] { get }
    
    func heightOfRowBySection( section : Int, row : Int ) -> CGFloat?
}

class TwitterDataSource : TableDataSource {
    var sectionsCount : Int { get {
            return 1
        }
    }
    var rowsCountBySection : [Int] {
        get {
            return [1]
        }
    }
    
    func heightOfRowBySection( section : Int, row : Int ) -> CGFloat?
    {
        return nil
    }
}

