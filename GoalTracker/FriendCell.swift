//
//  FriendCell.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 10/26/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        profileImageView.clipsToBounds = true;
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = kThemeColor.CGColor
        profileImageView.layer.cornerRadius = CGRectGetWidth(profileImageView.frame) / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
