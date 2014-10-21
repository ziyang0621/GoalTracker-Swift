//
//  FriendListViewController.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/19/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

protocol FriendListViewControllerDelegate {
    func selectedFriend(controller:FriendListViewController, friend:User)
}

class FriendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var followers: [User]?
    
    var delegate :FriendListViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Friend List"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        followers = [User]()
        
        fetchFollowerList()
    }
    
    func fetchFollowerList() {
        var verify = NSURL(string: kFollowerListURL)
        var request = NSMutableURLRequest(URL: verify)
        PFTwitterUtils.twitter().signRequest(request)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            var users = object["users"] as [NSDictionary]
            for userDict in users {
                var user = User(dictionary: userDict)
                println(user.screenname)
                self.followers?.append(user)
            }
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followers?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCellWithIdentifier("FriendCell") as UITableViewCell
        var friend = self.followers?[indexPath.row]
        cell.textLabel?.text = friend?.screenname
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let d = delegate {
            if let friend = self.followers?[indexPath.row]  {
                d.selectedFriend(self, friend: friend)
            }
        }
        navigationController?.popViewControllerAnimated(true)
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
