//
//  MainScreenDDM.swift
//  SwiftTemplateProject
//
//  Created by Hawk on 28/09/16.
//  Copyright © 2016 Hawk. All rights reserved.
//

import UIKit.UITableView

//Display Data Manager

protocol MainScreenDDMProtocol : UITableViewDelegate, UITableViewDataSource {}

class MainScreenDDM : NSObject, MainScreenDDMProtocol {
    
    var dataSource : TableDataSource!
    var delegate : MainScreenDelegate!
    
    init(dataSource: TableDataSource, delegate: MainScreenDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
        
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.rowsCountBySection[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
