//
//  ViewController.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/18/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLogin(sender: AnyObject) {
        PFTwitterUtils.logInWithBlock {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Twitter login.")
            } else if user.isNew {
                NSLog("User signed up and logged in with Twitter!")
            } else {
                NSLog("User logged in with Twitter!")
            }
        }
    }
}

