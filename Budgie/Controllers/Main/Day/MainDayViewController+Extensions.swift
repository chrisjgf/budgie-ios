//
//  MainDayViewController+Extensions.swift
//  Budgie
//
//  Created by Chris on 24/02/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import UIKit

// MARK: - UITableViewDelegate
extension MainDayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cells = daySelected.cells, cells.count > 0 else { return 1 }
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView
            .dequeueReusableCell(withIdentifier: ExpandedCell.identifier) as? ExpandedCell
        else {
            return UITableViewCell()
        }
        
        guard let cells = daySelected.cells, cells.count > 0 else {
            cell.viewModel = nil
            return cell
        }
        
        let dataSource = daySelected.cells?[indexPath.row]
        let viewModel = ExpandedCell.ViewModel.init(dataSource,
                                                    delegate: self,
                                                    swipeActions: [.delete, .edit])
        cell.viewModel = viewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = daySelected.cells?[indexPath.row] else { return }
        
        // If there are images stored, on click push image
        if let _ = cell.images{
            let controller = AddImageCollectionViewController.instantiate()
            controller.cell = cell
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension MainDayViewController: UITableViewDataSource {}
extension MainDayViewController: LocalManaging {}

extension MainDayViewController: StoryboardInstantiatable {
    static var storyboardName: String {
        return "Main"
    }
}
