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

class AddGoalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "onCancel")
        navigationItem.title = "Add Goal"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        
        tableView.registerNib(UINib(nibName: "AddGoalTextFieldCell", bundle: nil), forCellReuseIdentifier: kAddGoalTextFieldID)
        tableView.registerNib(UINib(nibName: "AddGoalLabelCell", bundle: nil), forCellReuseIdentifier: kAddGoalLabelID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onCancel() {
        dismissViewControllerAnimated(true, completion: nil)
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
            cell.textLabel?.text = "Select Friend"
            cell.textLabel?.textColor = UIColor.grayColor()
            cell.accessoryType = .DisclosureIndicator
            
            var upperDivider = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 1))
            upperDivider.backgroundColor = kCellDividerColor
            var lowerDivider = UIView(frame: CGRectMake(0, CGRectGetMaxY(cell.frame), CGRectGetWidth(tableView.frame), 1))
            lowerDivider.backgroundColor = kCellDividerColor
            
            cell.addSubview(upperDivider)
            cell.addSubview(lowerDivider)
            cell.bringSubviewToFront(upperDivider)
            cell.bringSubviewToFront(lowerDivider)
            return cell
        }
        return tableView.dequeueReusableCellWithIdentifier(kAddGoalTextFieldID) as AddGoalTextFieldCell
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
