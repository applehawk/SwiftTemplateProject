//
//  AppDelegateAssembler.swift
//  SwiftTemplateProject
//
//  Created by Hawk on 28/09/16.
//  Copyright © 2016 Hawk. All rights reserved.
//

class AppDelegateAssembler {
    func resolveDependencies(appDelegate: AppDelegate) {
        let appDelegateServices = [
            RootService(),
            ]
        appDelegate.servicesDispatcher = AppDelegateServiceDispatcher(services: appDelegateServices)
    }
}
