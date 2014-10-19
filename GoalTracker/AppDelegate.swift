//
//  AppDelegate.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/18/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

let parseApplicationId = "jJ8uwIwbayhLySJ3hIlAd2S3AjmqG2kMYkET3eRz"
let parseClientKey = "lubvDSEYJxGINkhLLMi0eMeasfmRipLgTcgx7J9r"
let twitterConsumerKey = "NAjAe0Tx05FmMUq8nIG4DhT44"
let twitterConsumerSecret = "KObQM1z4JdsmzZcOlDSiNzmUCsvdI5vw6ehl1HNkQIiIta1oOa"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotificaiton = "userDidLogoutNotification"
let kThemeColor = UIColor.colorWithRGBHex(0x34AADC, alpha: 1.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var sideMenuVC: RESideMenu?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.setApplicationId(parseApplicationId, clientKey: parseClientKey)
        PFTwitterUtils.initializeWithConsumerKey(twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        
        application.statusBarStyle = .LightContent
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().titleTextAttributes = titleDict
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().setBackgroundImage(UIColor.imageWithColor(kThemeColor), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().shadowImage = UIColor.imageWithColor(kThemeColor)
        UINavigationBar.appearance().translucent = true

        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogin", name: userDidLoginNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userDidLogoutNotificaiton, object: nil)
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            println("is logged in")
            userDidLogin()
        } else {
            println("is not logged in")
        }
        
        return true
    }
    
    func userDidLogin() {
        var goalListVC = UIStoryboard.goalListViewController()
        var goalListNav = UINavigationController(rootViewController: goalListVC!)
        var sidePanelVC = UIStoryboard.sidePanelViewController()
        
        sideMenuVC = RESideMenu(contentViewController: goalListNav, leftMenuViewController: sidePanelVC, rightMenuViewController: nil)
        
        self.window?.rootViewController = sideMenuVC
    }
    
    func userDidLogout() {
        var loginVC = UIStoryboard.loginViewController()
        window?.rootViewController = loginVC
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    


}

