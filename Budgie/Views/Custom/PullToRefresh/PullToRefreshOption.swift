//
//  NavigationExtension.swift
//  Budgie
//
//  Created by Christopher Fulford
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import UIKit

struct PullToRefreshConst {
    private(set) var height: CGFloat
    private(set) var animationDuration: Double
    
    init(height: CGFloat = 50.0,
         animationDuration: Double = 0.25)
    {
        self.height = height
        self.animationDuration = animationDuration
    }
}
