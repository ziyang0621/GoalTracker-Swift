//
//  SidePanelViewController.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/19/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

let kSideMenuCellID = "SideMenuCell"
let kProfileImageURLStringKey = "profileImageKey"

class SidePanelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: kSideMenuCellID)
        
        profileImageView.clipsToBounds = true;
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = kThemeColor.CGColor
        profileImageView.layer.cornerRadius = CGRectGetWidth(profileImageView.frame) / 2
        
        tableView.backgroundColor = UIColor.clearColor()
        view.backgroundColor = UIColor.clearColor()
        
        PFTwitterUtils.getUserProfileImage(PFTwitterUtils.twitter().userId, completion: {
            (urlString, error) -> () in
            if error == nil {
                self.profileImageView.setImageWithURL(NSURL(string: urlString!)!)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kSideMenuCellID) as SideMenuCell
        if indexPath.row == 0 {
            cell.iconImageView.image = UIImage(named: "goal")
            cell.menuTextLabel.text = "Goal List"
        } else if indexPath.row == 1 {
            cell.iconImageView.image = UIImage(named: "signout")
            cell.menuTextLabel.text = "Sign Out"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            var goalListVC = UIStoryboard.goalListViewController()
            goalListVC?.listDate = NSDate()
            var goalListNav = UINavigationController(rootViewController: goalListVC!)
            AppDelegateAccessor.frostedMenuVC?.contentViewController = goalListNav
            AppDelegateAccessor.frostedMenuVC?.hideMenuViewController()
        }
        else if indexPath.row == 1 {
            onSignout()
        }
    }
    
    func onSignout() {
        let alertController = UIAlertController(title: "Sign Out", message: "Do you want to sign out?", preferredStyle: .ActionSheet)
        
        let removeAction = UIAlertAction(title: "Yes, sign out", style: .Destructive, handler: {
            action in
                PFUser.logOut()
                AppDelegateAccessor.userDidLogout()
            }
        )
        alertController.addAction(removeAction)
        
        let cancelAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
