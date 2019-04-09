//
//  TableViewConfigurable.swift
//  Budgie
//
//  Created by Chris on 23/02/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import UIKit

protocol TableViewConfigurable {
    var tableView: UITableView! { get set }
    var rowHeight: CGFloat { get }
    func handleSwipeAction(for indexPath: IndexPath, _ action: SwipeButtonState)
    func swipeActionTapped(_ cell: UITableViewCell, action: SwipeButtonState)
    func reloadTable()
}

extension TableViewConfigurable where Self: UIViewController {
    var rowHeight: CGFloat {
        if DeviceType.isiPhone5 {
            return 56.0
        } else if DeviceType.isiPhone6P {
            return 72.0
        } else {
            return 64.0
        }
    }
    func swipeActionTapped(_ cell: UITableViewCell, action: SwipeButtonState) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        print(String(describing: action))
        self.handleSwipeAction(for: indexPath, action)
    }
    func handleSwipeAction(for indexPath: IndexPath, _ action: SwipeButtonState) {}
    func reloadTable() {
        tableView.reloadData()
    }
}
