//
//  ServiceDispatcher.swift
//  BabyBee
//
//  Created by Hawk on 10/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

import UIKit.UIApplication

class AppDelegateServiceDispatcher : NSObject, UIApplicationDelegate {
    // MARK: - Properties
    let services: [UIApplicationDelegate]
    // MARK: - Constructors
    init(services: [UIApplicationDelegate]) {
        self.services = services
    }
    // MARK: - Methods
    
    // MARK: Main functions of AppDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        for service in services {
            if let didFinishLaunchResult = service.application?(application, didFinishLaunchingWithOptions: launchOptions), didFinishLaunchResult == false
            {
                return false
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        for service in services {
            if let willFinishLaunchResult = service.application?(application, willFinishLaunchingWithOptions: launchOptions), willFinishLaunchResult == false
            {
                return false
            }
        }
        return true
    }
    // MARK: Helper function for Notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        for service in services {
            service.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        for service in services {
            service.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
    
    // MARK: Open by URL / URLSchemes Handlers
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        for service in services {
            if let openUrlResult = service.application?(app, open: url, options: options), openUrlResult == false {
                return false
            }
        }
        return true
    }
    // MARK: Handlers of app mode transitions (Active, Inactive, Background, Foreground, Suspended)
    func applicationWillTerminate(_ application: UIApplication) {
        for service in services {
            service.applicationWillTerminate?(application)
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        for service in services {
            service.applicationDidBecomeActive?(application)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        for service in services {
            service.applicationWillResignActive?(application)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        for service in services {
            service.applicationDidEnterBackground?(application)
        }
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        for service in services {
            service.applicationDidFinishLaunching?(application)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        for service in services {
            service.applicationWillEnterForeground?(application)
        }
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        for service in services {
            service.applicationDidReceiveMemoryWarning?(application)
        }
    }
    /* //Not handled
     
    func applicationSignificantTimeChange(_ application: UIApplication) {
        for service in services {
            service.applicationSignificantTimeChange?(application)
        }
    }
     
    func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        for service in services {
            service.applicationProtectedDataDidBecomeAvailable?(application)
        }
    }
    
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        for service in services {
            service.applicationShouldRequestHealthAuthorization?(application)
        }
    }
    
    func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        for service in services {
            service.applicationProtectedDataWillBecomeUnavailable?(application)
        }
    }
    */
}
