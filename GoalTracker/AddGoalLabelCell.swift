//
//  AddGoalLabelCell.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/19/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

class AddGoalLabelCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        textLabel?.textColor = UIColor.grayColor()
        accessoryType = .DisclosureIndicator
        
        var upperDivider = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(bounds), 1))
        upperDivider.backgroundColor = kCellDividerColor
        var lowerDivider = UIView(frame: CGRectMake(0, CGRectGetMaxY(bounds), CGRectGetWidth(bounds), 1))
        lowerDivider.backgroundColor = kCellDividerColor
        
        addSubview(upperDivider)
        addSubview(lowerDivider)
        bringSubviewToFront(upperDivider)
        bringSubviewToFront(lowerDivider)
    }
    
}
