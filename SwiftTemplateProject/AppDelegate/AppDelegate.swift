//
//  AppDelegate.swift
//  SwiftTemplateProject
//
//  Created by Hawk on 28/09/16.
//  Copyright © 2016 Hawk. All rights reserved.
//

import UIKit
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // Injected by DI Framework
    var servicesDispatcher : UIApplicationDelegate!
    
    override init() {
        super.init()
        AppDelegateAssembler().resolveDependencies(appDelegate: self)
    }

    // MARK: Main functions of AppDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let didFinishResult = servicesDispatcher.application?(application, didFinishLaunchingWithOptions: launchOptions), didFinishResult == true {
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        if let willFinishResult = servicesDispatcher.application?(application, willFinishLaunchingWithOptions: launchOptions), willFinishResult == true {
            return true
        }
        return false
    }
    
    // MARK: Helper function for Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        servicesDispatcher.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        servicesDispatcher.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
    
        // MARK: Open by URL / URLSchemes Handlers
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let openUrlResult = servicesDispatcher.application?(app, open: url, options: options),
            openUrlResult == true {
            return true
        }
        return false
    }

    // MARK: - Handlers of app mode transitions (Active, Inactive, Background, Foreground, Suspended)
    // MARK: XCode Template generated UIApplicationDelegate methods
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        servicesDispatcher.applicationWillResignActive?(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        servicesDispatcher.applicationDidEnterBackground?(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        servicesDispatcher.applicationWillEnterForeground?(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        servicesDispatcher.applicationDidBecomeActive?(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        servicesDispatcher.applicationWillTerminate?(application)
    }
    // MARK: Other UIApplicationDelegate methods
    func applicationDidFinishLaunching(_ application: UIApplication) {
        //Posted immediately after the app finishes launching.
        servicesDispatcher.applicationDidFinishLaunching?(application)
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        //Posted when the app receives a warning from the operating system about low memory availability.
        servicesDispatcher.applicationDidReceiveMemoryWarning?(application)
    }

}

