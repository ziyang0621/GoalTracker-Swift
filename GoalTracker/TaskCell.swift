//
//  TaskCell.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/21/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

protocol TaskCellDelegate {
    func tappedCheckbox(cell: TaskCell, isCompleted: Bool, index: Int)
}

class TaskCell: UITableViewCell {

    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var isCompleted = false
    
    var isCompletedEarly = false
    
    var taskDate: NSDate?
    
    var cellIndex = 0
    
    var delegate :TaskCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        timeLabel.text = timeFormatter.stringFromDate(taskDate!)
        if !isCompleted {
            descriptionLabel.textColor = kGrayColor
            timeLabel.textColor = kGrayColor
            checkImageView.image = checkImageView.image?.imageWithColor(kGrayColor)
        } else {
            if isCompletedEarly {
                descriptionLabel.textColor = kGreenColor
                timeLabel.textColor = kGreenColor
                checkImageView.image = checkImageView.image?.imageWithColor(kGreenColor)
            } else {
                descriptionLabel.textColor = kYellowColor
                timeLabel.textColor = kYellowColor
                checkImageView.image = checkImageView.image?.imageWithColor(kYellowColor)
            }
        }

        var tapGesture = UITapGestureRecognizer(target: self, action: "handleCheckboxTap")
        checkImageView.addGestureRecognizer(tapGesture)
    }
    
    func handleCheckboxTap() {
        isCompleted = !isCompleted
        if let d = delegate {
            delegate.tappedCheckbox(self, isCompleted: isCompleted, index: cellIndex)
        }
    }
    
}
