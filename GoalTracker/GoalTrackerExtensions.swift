//
//  GoalTrackerExtensions.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/19/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//
import Foundation

extension NSDate {
    class func beginningOfDay(date: NSDate) -> NSDate {
        var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var comps = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
        return calendar.dateFromComponents(comps)!
    }
    
    class func endOfDay(date: NSDate) -> NSDate {
        var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var comps = NSDateComponents()
        comps.day = 1
        var newDate = calendar.dateByAddingComponents(comps, toDate: NSDate.beginningOfDay(date), options: nil)
        newDate =  newDate?.dateByAddingTimeInterval(-1)
        return newDate!
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
}