//
//  CellSwipeable.swift
//  Budgie
//
//  Created by Chris on 09/03/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import UIKit
import MGSwipeTableCell

protocol Swipeable {
    func setSwipe(as setting: SwipeButtonState, for index: IndexPath) -> MGSwipeButton?
    func editTapped(_ indexPath: IndexPath)
    func clearTapped(_ indexPath: IndexPath)
    func deleteTapped(_ indexPath: IndexPath)
}

extension Swipeable where Self: UIViewController {
    func setSwipe(as setting: SwipeButtonState, for indexPath: IndexPath) -> MGSwipeButton? {
        var button: MGSwipeButton!
        
        switch setting {
        case .edit:
            button = MGSwipeButton(title: "",
                                   icon: UIImage(named:"edit"),
                                   backgroundColor: UIColor.white,
                                   callback: {(sender: MGSwipeTableCell!)
                                    -> Bool in
                print("Edited!")
                self.editTapped(indexPath)
                return true
            })
        case .clear:
            button = MGSwipeButton(title: "",
                                   icon: UIImage(named:"clear"),
                                   backgroundColor: UIColor.white,
                                   callback: {(sender: MGSwipeTableCell!)
                                    -> Bool in
                print("Cleared!")
                self.clearTapped(indexPath)
                return true
            })
            button.tag = 1
        case .delete:
            button = MGSwipeButton(title: "",
                                   icon: UIImage(named:"trash"),
                                   backgroundColor: UIColor.white,
                                   callback: {(sender: MGSwipeTableCell!)
                                    -> Bool in
                print("Deleted!")
                self.deleteTapped(indexPath)
                return true
            })
        }
        return button
    }
}
