//
//  ViewController.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/18/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = UIImage(named: "goalLogin")!.imageWithColor(kThemeColor)
        backgroundImageView.alpha = 0.2
        
        loginBtn.tintColor = UIColor.whiteColor()
        loginBtn.backgroundColor = kThemeColor
        loginBtn.clipsToBounds = true
        loginBtn.layer.cornerRadius = 5
        loginBtn.alpha = 0.7
        
        titleLabel.textColor = kThemeColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func prepareLogin() {
        UIView.animateWithDuration(2.0, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.loginBtn.alpha = 0
            self.titleLabel.alpha = 0
            self.backgroundImageView.alpha = 0.8
        }) { (finished) -> Void in
            if (finished) {
                UIView.beginAnimations("fade in", context: nil)
                UIView.setAnimationDuration(1.5)
                var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.userDidLogin()
                UIView.commitAnimations()
            }
        }
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        PFTwitterUtils.logInWithBlock {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Twitter login.")
            } else if user.isNew {
                println("User signed up and logged in with Twitter!")
                self.prepareLogin()
            } else {
                println("User logged in with Twitter!")
                self.prepareLogin()
            }
        }
    }
}

