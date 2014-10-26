
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
let kFollowerListURL = "https://api.twitter.com/1.1/followers/list.json"
let kSendMessageURL = "https://api.twitter.com/1.1/direct_messages/new.json"
let kProfileURL = "https://api.twitter.com/1.1/users/show.json"
let kThemeColor = UIColor.colorWithRGBHex(0x34AADC, alpha: 1.0)
let kCellDividerColor = UIColor.colorWithRGBHex(0xF7F7F7, alpha: 1.0)
let kRedColor = UIColor.colorWithRGBHex(0xFF5B37, alpha: 1.0)
let dateFormatter = NSDateFormatter()
let timeFormatter = NSDateFormatter()
let fullFormatter = NSDateFormatter()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var frostedMenuVC: REFrostedViewController?

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

        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            println("is logged in")
            userDidLogin()
        } else {
            println("is not logged in")
        }
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        timeFormatter.dateFormat = "hh:mm a"
        fullFormatter.dateFormat = "MM/dd/yyyy' 'hh:mm a"
        
        if(UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:"))) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        }
        
        application.applicationIconBadgeNumber = 0
                
        return true
    }
    
    func userDidLogin() {
        var goalListVC = UIStoryboard.goalListViewController()
        goalListVC?.listDate = NSDate()
        var goalListNav = UINavigationController(rootViewController: goalListVC!)
        var sidePanelVC = UIStoryboard.sidePanelViewController()
        
        frostedMenuVC = REFrostedViewController(contentViewController: goalListNav, menuViewController: sidePanelVC)
        frostedMenuVC?.direction = .Left
        frostedMenuVC?.liveBlur = true
        self.window?.rootViewController = frostedMenuVC
    }
    
    func userDidLogout() {
        var loginVC = UIStoryboard.loginViewController()
        window?.rootViewController = loginVC
        NSUserDefaults.standardUserDefaults().removeObjectForKey(kProfileImageURLStringKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        var objectId = notification.userInfo!["objectId"] as String
        var query = PFQuery(className: "Task")
        query.whereKey("objectId", equalTo: objectId)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                var object = objects[0] as PFObject
                var friendData = object["friend"] as NSData
                var friendDict = NSJSONSerialization.JSONObjectWithData(friendData, options: nil, error: nil) as NSDictionary
                var friend = User(dictionary: friendDict)
                
                println(friend.userId!)
                
                var msg = "didnt \(notification.alertBody!) - sent from GoalTracker"
                PFTwitterUtils.sendMessage(friend.userId!, message: msg) { (error) -> () in
                    if error == nil {
                        println("sent msg to Twitter")
                    }
                }
            }
        }
        
        if application.applicationState == .Active {
            var alert = UIAlertView(title: "Reminder", message: notification.alertBody, delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
        application.applicationIconBadgeNumber = 0
        
        NSNotificationCenter.defaultCenter().postNotificationName(kRefreshGoalListTableView, object: nil)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        UIApplication.sharedApplication().arrangeBadgeNumber()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0;
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UIApplication.sharedApplication().arrangeBadgeNumber()
    }
    


}

