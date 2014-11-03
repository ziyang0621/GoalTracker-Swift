//
//  GoalButton.swift
//  GoalTracker
//
//  Created by Ziyang Tan on 11/2/14.
//  Copyright (c) 2014 Ziyang Tan. All rights reserved.
//

import UIKit

class GoalButton: UIButton {
    
    override func intrinsicContentSize() -> CGSize {
        var contentSize = super.intrinsicContentSize()
        return CGSizeMake(contentSize.width + 50, contentSize.height + 10);
    }
}
