//
//  GoalListViewController.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/19/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

let kTaskCellID = "TaskCell"
let kRefreshGoalListTableView = "refreshGoalListTableView"

class GoalListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskArray: [PFObject]?
    
    var listDate: NSDate?
    
    var refreshControl = UIRefreshControl()
    
    var fromCalendarView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !fromCalendarView {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "onMenu")
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "onAdd")
        } else {
             navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "onClose")
        }
        
        navigationItem.title = dateFormatter.stringFromDate(listDate!)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: kTaskCellID)
        
        if !fromCalendarView {
            refreshControl.addTarget(self, action: "loadTasks", forControlEvents: .ValueChanged)
        } else {
            refreshControl.addTarget(self, action: "loadSingleTask", forControlEvents: .ValueChanged)
        }
        tableView.addSubview(refreshControl)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTableView", name: kRefreshGoalListTableView, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !fromCalendarView {
            loadTasks()
        }
    }
    
    func refreshTableView() {
        tableView.reloadData()
    }
    
    func loadTasks() {
        var query = PFQuery(className: "Task")
        query.whereKey("taskDate", greaterThanOrEqualTo: NSDate.beginningOfDay(listDate!))
        query.whereKey("taskDate", lessThanOrEqualTo: NSDate.endOfDay(listDate!))
        query.whereKey("userId", equalTo: PFTwitterUtils.twitter().userId)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.taskArray = objects as? [PFObject]
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func loadSingleTask() {
        var task = taskArray![0]
        var query = PFQuery(className: "Task")
        query.whereKey("objectId", equalTo: task.objectId)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.taskArray = objects as? [PFObject]
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func loadTasksForCalender(index :Int, completion: (objects: [AnyObject]?, error: NSError?) ->()) {
        var task = taskArray![index]
        var parent = task["parent"] as? PFObject
        var query = PFQuery(className: "Task")
        query.whereKey("parent", equalTo: parent)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                completion(objects: objects, error: nil)
            } else {
                completion(objects: nil, error: error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onMenu() {
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.frostedMenuVC?.presentMenuViewController()
    }
    
    func onAdd() {
        var addGoalVC = UIStoryboard.addGoalViewController()
        var addNav = UINavigationController(rootViewController: addGoalVC!)
        presentViewController(addNav, animated: true, completion: nil)
    }
    
    func onClose() {
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kTaskCellID) as TaskCell
        
        var task = taskArray?[indexPath.row]
        cell.descriptionLabel.text = task!["description"] as? String
        
        cell.taskDate = task!["taskDate"] as? NSDate
        
        cell.isCompletedEarly = task!["completedEarly"] as Bool
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !fromCalendarView {
            var calendarVC = UIStoryboard.goalCalendarViewController()
            var backBarButton = UIBarButtonItem(title: "Back", style: .Bordered, target: nil, action: nil)
            navigationItem.backBarButtonItem = backBarButton
            var progressView = MRProgressOverlayView.showOverlayAddedTo(self.navigationController?.view, animated: false)
            loadTasksForCalender(indexPath.row, completion: {
                (objects, error) -> () in
                if error == nil {
                    calendarVC?.goalTasks = objects as? [PFObject]
                    MRProgressOverlayView.dismissOverlayForView(self.navigationController?.view, animated: false)
                    self.navigationController?.pushViewController(calendarVC!, animated: true)
                }
            })
        }
    }
    
    func tappedCheckbox(cell: TaskCell, isCompleted: Bool, index: Int) {
        var object = self.taskArray?[index]
        object?["isCompleted"] = isCompleted
        if isCompleted {
            var taskDate = object?["taskDate"] as NSDate
            if taskDate.isLater(NSDate()) {
                object?["completedEarly"] = true
            }
        }
        object?.saveInBackgroundWithBlock({
            (succeeded: Bool, error: NSError!) -> Void in
            if error == nil {
                println("updated object")
                var indexPath = NSIndexPath(forRow: index, inSection: 0)
                self.taskArray?[index] = object!
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                if isCompleted {
                    UIApplication.sharedApplication().cancelScheduledAlarm(object!)
                }
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
