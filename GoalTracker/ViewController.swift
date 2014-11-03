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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = UIImage(named: "goalLogin")!.imageWithColor(kThemeColor)
        backgroundImageView.alpha = 0.2
        
        loginBtn.tintColor = UIColor.whiteColor()
        loginBtn.backgroundColor = kThemeColor
        loginBtn.clipsToBounds = true
        loginBtn.layer.cornerRadius = 5
        loginBtn.alpha = 0.7
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        PFTwitterUtils.logInWithBlock {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Twitter login.")
            } else if user.isNew {
                println("User signed up and logged in with Twitter!")
                var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.userDidLogin()
            } else {
                println("User logged in with Twitter!")
                var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.userDidLogin()
            }
        }
    }
}

