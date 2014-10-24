//
//  GoalCalendarViewController.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/21/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

class GoalCalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RSDFDatePickerViewDelegate, RSDFDatePickerViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calendarContainerView: UIView!
    
    var calendarView: RSDFDatePickerView?
    
    var goalTasks: [PFObject]?
    
    var goalDates = [NSDate]()
    
    var completedDates = [NSDate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Progress"
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        calendarView = RSDFDatePickerView(frame: calendarContainerView.frame)
        calendarView?.dataSource = self
        calendarView?.delegate = self
        calendarContainerView.addSubview(calendarView!)
        
        loadDates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDates() {
        
        goalDates.removeAll(keepCapacity: false)
        completedDates.removeAll(keepCapacity: false)
        for object in goalTasks! {
            var date = object["taskDate"] as? NSDate
            var isCompleted = object["isCompleted"] as? Bool
            if isCompleted! {
                completedDates.append(date!)
                println("completed date: \(date)")
            }
            goalDates.append(date!)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("CalendarCell") as UITableViewCell
    }
    
    func datePickerView(view: RSDFDatePickerView!, didSelectDate date: NSDate!) {
        println(fullFormatter.stringFromDate(date))
        for task in goalTasks! {
            var aDate = task["taskDate"] as? NSDate
            if aDate!.sameDay(date) {
                var goalListVC = UIStoryboard.goalListViewController()
                goalListVC?.fromCalendarView = true
                goalListVC?.listDate = aDate
                goalListVC?.taskArray = [PFObject]()
                goalListVC?.taskArray!.append(task)
                var goalListNav = UINavigationController(rootViewController: goalListVC!)
                self.presentViewController(goalListNav, animated: true, completion: nil)
            }
        }
    }
    
    func datePickerView(view: RSDFDatePickerView!, shouldMarkDate date: NSDate!) -> Bool {
        for aDate in goalDates {
            if aDate.sameDay(date) {
                return true
            }
        }
        return false
    }
    
    func datePickerView(view: RSDFDatePickerView!, isCompletedAllTasksOnDate date: NSDate!) -> Bool {
        for aDate in completedDates {
            if aDate.sameDay(date) {
                return true
            }
        }
        return false
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
