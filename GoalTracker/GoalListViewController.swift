//
//  GoalListViewController.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/19/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

let kTaskCellID = "TaskCell"

class GoalListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskArray: [PFObject]?
    
    var listDate: NSDate?
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "onMenu")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "onAdd")
        navigationItem.title = dateFormatter.stringFromDate(listDate!)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: kTaskCellID)
        
        refreshControl.addTarget(self, action: "loadTasks", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        loadTasks()
    }
    
    func loadTasks() {
        var query = PFQuery(className: "Task")
        query.whereKey("taskDate", greaterThanOrEqualTo: NSDate.beginningOfDay(listDate!))
        query.whereKey("taskDate", lessThanOrEqualTo: NSDate.endOfDay(listDate!))
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.taskArray = objects as? [PFObject]
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onMenu() {
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.sideMenuVC?.presentLeftMenuViewController()
    }
    
    func onAdd() {
        var addGoalVC = UIStoryboard.addGoalViewController()
        var addNav = UINavigationController(rootViewController: addGoalVC!)
        presentViewController(addNav, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kTaskCellID) as TaskCell
        
        var task = taskArray?[indexPath.row]
        cell.descriptionLabel.text = task!["description"] as? String
        
        var taskDate = task!["taskDate"] as? NSDate
        cell.timeLabel.text = timeFormatter.stringFromDate(taskDate!)
        
        var isCompleted = task!["isCompleted"] as? Bool
        if let isCom = isCompleted {
            if isCom {
                cell.checkImageView.image = UIImage(named: "checked")
                cell.isCompleted = true
            } else {
                cell.checkImageView.image = UIImage(named: "unchecked")
                cell.isCompleted = false
            }
        }
       
        cell.cellIndex = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tappedCheckbox(cell: TaskCell, isCompleted: Bool, index: Int) {
        var task = taskArray?[index]
        var objID = task?.objectId
        var query = PFQuery(className: "Task")
        query.getObjectInBackgroundWithId(objID, block: {
            (object: PFObject!, error: NSError!) -> Void in
            if error == nil {
                object["isCompleted"] = isCompleted
                object.saveInBackgroundWithBlock({
                    (succeeded: Bool, error: NSError!) -> Void in
                    if error == nil {
                        println("updated object")
                        var indexPath = NSIndexPath(forRow: index, inSection: 0)
                        self.taskArray?[index] = object
                        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                    }
                })
            }
        })
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
