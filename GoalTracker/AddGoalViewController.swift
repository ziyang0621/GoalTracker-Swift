//
//  AddGoalViewController.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/19/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

let kAddGoalTextFieldID = "AddGoalTextFieldCell"
let kAddGoalLabelID = "AddGoalLabelCell"


class AddGoalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FriendListViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedFriend: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "onCancel")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: "onCreate")
        navigationItem.title = "Add Goal"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        
        tableView.registerNib(UINib(nibName: "AddGoalTextFieldCell", bundle: nil), forCellReuseIdentifier: kAddGoalTextFieldID)
        tableView.registerNib(UINib(nibName: "AddGoalLabelCell", bundle: nil), forCellReuseIdentifier: kAddGoalLabelID)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onCreate() {
       
        var descriptionCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as AddGoalTextFieldCell
        var startDateCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as AddGoalTextFieldCell
        var goalDateCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as AddGoalTextFieldCell
        var remindCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 3)) as AddGoalTextFieldCell
        var friendCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 4)) as AddGoalLabelCell
        
        var remindTime = timeFormatter.dateFromString(remindCell.addGoalTextField.text)
        var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var remindComponents = calendar!.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute, fromDate: remindTime!)
        var hour = remindComponents.hour
        var min = remindComponents.minute
        
        var startDate = dateFormatter.dateFromString(startDateCell.addGoalTextField.text)
        var startComponents = calendar!.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute, fromDate: startDate!)
        startComponents.hour = hour
        startComponents.minute = min
        var newStartDate = calendar!.dateFromComponents(startComponents)
        
        var goalDate = dateFormatter.dateFromString(goalDateCell.addGoalTextField.text)
        var goalComponents = calendar!.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute, fromDate: goalDate!)
        goalComponents.hour = hour
        goalComponents.minute = min
        var newGoalDate = calendar!.dateFromComponents(goalComponents)
        
        println(fullFormatter.stringFromDate(remindTime!))
        println(fullFormatter.stringFromDate(newStartDate!))
        println(fullFormatter.stringFromDate(newGoalDate!))
        
        var goal = PFObject(className: "Goal")
        goal["description"] = descriptionCell.addGoalTextField.text
        goal["startDate"] = newStartDate
        goal["goalDate"] = newGoalDate
        goal["friend"] = NSJSONSerialization.dataWithJSONObject(selectedFriend!.dictionary, options: nil, error:nil)
        goal["isCompleted"] = false
        
        var progressView = MRProgressOverlayView.showOverlayAddedTo(self.navigationController?.view, animated: false)
        goal.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError!) -> Void in
            if error == nil {
                if succeeded {
                    println("saved goal")
                    
                    var taskArray = PFObject.createGoalTasks(goal)
                    
                    PFObject.saveAllInBackground(taskArray, block: {
                        (succeeded: Bool, error: NSError!) -> Void in
                        println("save all tasks")
                        for myTask in taskArray {
                            UIApplication.sharedApplication().scheduleAlarm(myTask)
                        }
                        MRProgressOverlayView.dismissOverlayForView(self.navigationController?.view, animated: false)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRectMake(0, 0, 320, 40))
        var headerLabel = UILabel(frame: CGRectMake(10, 10, 320, 40))
        headerLabel.textColor = UIColor.grayColor()
        if section == 0 {
            headerLabel.text = "Description:"
        } else if section == 1 {
            headerLabel.text = "Start Date:"
        } else if section == 2 {
            headerLabel.text = "Goal Date:"
        } else if section == 3 {
            headerLabel.text = "Reminder:"
        } else {
            headerLabel.text = "Add Friend:"
        }
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 4 {
            var cell = tableView.dequeueReusableCellWithIdentifier(kAddGoalLabelID) as AddGoalLabelCell
            cell.textLabel.text = selectedFriend?.screenname ?? "select friend"
            return cell
        }
        if indexPath.section != 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier(kAddGoalTextFieldID) as AddGoalTextFieldCell
            if indexPath.section == 3 {
                cell.textFieldType = .TimePicker
            } else {
                cell.textFieldType = .DatePicker
            }
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier(kAddGoalTextFieldID) as AddGoalTextFieldCell
            cell.textFieldType = .Regular
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 4 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            var friendListVC = UIStoryboard.friendListViewController()!
            friendListVC.delegate = self
            navigationController?.pushViewController(friendListVC, animated: true)
        }
    }
    
    func selectedFriend(controller: FriendListViewController, friend: User) {
        selectedFriend = friend
        var indexPath = NSIndexPath(forRow: 0, inSection: 4)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation:.None)
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
