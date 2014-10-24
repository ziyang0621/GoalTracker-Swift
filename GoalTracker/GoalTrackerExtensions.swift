//
//  GoalTrackerExtensions.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/19/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//
import Foundation

extension PFTwitterUtils {
    class func fetchFollowerList(completion: (users: [NSDictionary]?, error: NSError?) ->()) {
        var verify = NSURL(string: kFollowerListURL)
        var request = NSMutableURLRequest(URL: verify!)
        twitter().signRequest(request)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if error == nil {
                var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                var users = object["users"] as [NSDictionary]
                completion(users: users, error: nil)
            } else {
                completion(users: nil, error: error)
            }
        })
    }
    
    class func sendMessage(userId: String, message: String, completion: (error: NSError?) ->()) {
        var msgString = message.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        var verify = NSURL(string: kSendMessageURL)
        var bodyString = "text=\(msgString!)&user_id=\(userId)"
        var request = NSMutableURLRequest(URL: verify!)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        twitter().signRequest(request)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if error == nil {
                completion(error: nil)
            } else {
                println(error)
                completion(error: error)
            }
        })
    }
}


extension UIApplication {
    func scheduleAlarm(object: PFObject) {
        var taskDate = object["taskDate"] as? NSDate
        if taskDate!.compare(NSDate()) == .OrderedDescending {
            var notiAlarm = UILocalNotification()
            var taskName = object["description"] as? String
            notiAlarm.alertBody = "\(taskName!) due at \(fullFormatter.stringFromDate(taskDate!))."
            notiAlarm.fireDate = taskDate
            notiAlarm.timeZone = NSTimeZone.systemTimeZone()
            notiAlarm.soundName = UILocalNotificationDefaultSoundName
            notiAlarm.userInfo = ["objectId": object.objectId]
            notiAlarm.applicationIconBadgeNumber = 1
            
            scheduleLocalNotification(notiAlarm)
        }
    }
    
    func cancelScheduledAlarm(object: PFObject) {
        var scheduledArray = Array(scheduledLocalNotifications)
        for noti in scheduledArray {
            var myNoti = noti as UILocalNotification
            var name = myNoti.userInfo!["objectId"] as String
            if name == object.objectId {
                cancelLocalNotification(myNoti)
            }
        }
    }
    
    func arrangeBadgeNumber() {
        var scheduledArray = scheduledLocalNotifications
        var fireDates = [NSDate]()
        for noti in scheduledArray {
            var myNoti = noti as UILocalNotification
            fireDates.append(myNoti.fireDate!)
        }
        fireDates.sort{$0.compare($1) == NSComparisonResult.OrderedAscending}
        for noti in scheduledArray {
            var myNoti = noti as UILocalNotification
            myNoti.applicationIconBadgeNumber = find(fireDates, noti.fireDate)! + 1
        }
        scheduledLocalNotifications = scheduledArray
    }
}


extension NSDate {
    class func beginningOfDay(date: NSDate) -> NSDate {
        var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var comps = calendar!.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
        return calendar!.dateFromComponents(comps)!
    }
    
    class func endOfDay(date: NSDate) -> NSDate {
        var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var comps = NSDateComponents()
        comps.day = 1
        var newDate = calendar!.dateByAddingComponents(comps, toDate: NSDate.beginningOfDay(date), options: nil)
        newDate =  newDate?.dateByAddingTimeInterval(-1)
        return newDate!
    }
    
    func sameDay(date: NSDate) -> Bool {
        var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var compsOne = calendar!.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
        var newDate = calendar!.dateFromComponents(compsOne)
        
        var compsTwo = calendar!.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: self)
        var newSelf = calendar!.dateFromComponents(compsTwo)
        
        var result = newDate?.isEqualToDate(newSelf!)
        if  result! {
            return true
        }
        return false
    }
}

extension UIColor {
    class func imageWithColor(color :UIColor) -> UIImage {
        var rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func colorWithRGBHex(hex: Int, alpha: Float = 1.0) -> UIColor {
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue:CGFloat(b / 255.0), alpha: CGFloat(alpha))
    }
}

extension UIImage {
    func imageWithColor(color :UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        var context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        var rect = CGRectMake(0, 0, self.size.width, self.size.height)
        CGContextClipToMask(context, rect, self.CGImage)
        color.setFill()
        CGContextFillRect(context, rect)
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }

    class func sidePanelViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("SidePanelViewController") as? SidePanelViewController
    }
    
    class func goalListViewController() -> GoalListViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("GoalListViewController") as? GoalListViewController
    }
    
    class func loginNavigationViewController() -> UINavigationController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("LoginNavigationController") as? UINavigationController
    }
    
    class func loginViewController() -> ViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("LoginViewController") as? ViewController
    }
    
    class func addGoalViewController() -> AddGoalViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("AddGoalViewController") as? AddGoalViewController
    }
    
    class func friendListViewController() -> FriendListViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("FriendListViewController") as? FriendListViewController
    }
    
    class func goalCalendarViewController() -> GoalCalendarViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("GoalCalendarViewController") as? GoalCalendarViewController
    }
}