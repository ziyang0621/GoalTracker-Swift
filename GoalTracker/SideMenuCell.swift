//
//  SideMenuCell.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/24/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var menuTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        backgroundColor = UIColor.clearColor()
        
        menuTextLabel.textColor = kThemeColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        iconImageView.image = iconImageView.image?.imageWithColor(kThemeColor)
    }
    
}
