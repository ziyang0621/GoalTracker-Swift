//
//  AddGoalTextFieldCell.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/19/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

enum TextFieldType {
    case Regular
    case DatePicker
    case TimePicker
}

class AddGoalTextFieldCell: UITableViewCell {

    @IBOutlet weak var addGoalTextField: UITextField!
    
    var textFieldType: TextFieldType!
    
    var datePickerView: UIDatePicker!
    
    let formatter = NSDateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        var toolBar = UIToolbar(frame: CGRectMake(0, 0, CGRectGetWidth(bounds), 30))
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "resignTextField")]
        toolBar.sizeToFit()
        addGoalTextField.inputAccessoryView = toolBar
        
        if textFieldType! != .Regular {
            setUpPicker()
        }
    }
    
    func resignTextField() {
        addGoalTextField.resignFirstResponder()
        if textFieldType! != .Regular {
            addGoalTextField.text = formatter.stringFromDate(datePickerView.date)
        }
    }
    
    func setUpPicker() {
        datePickerView = UIDatePicker()
        if textFieldType! == .DatePicker {
            datePickerView.datePickerMode = .Date
            formatter.dateFormat = "MM/dd/yyyy"
            datePickerView.minimumDate = NSDate()
        } else if textFieldType! == .TimePicker {
            datePickerView.datePickerMode = .Time
            formatter.dateFormat = "hh:mm a"
        }
        datePickerView.backgroundColor = UIColor.whiteColor()
        addGoalTextField.inputView = datePickerView
        datePickerView.addTarget(self, action: "handleDateChanged:", forControlEvents: .ValueChanged)
    }
    
    func handleDateChanged(datePicker: UIDatePicker) {
        addGoalTextField.text = formatter.stringFromDate(datePicker.date)
    }
    
    
}
