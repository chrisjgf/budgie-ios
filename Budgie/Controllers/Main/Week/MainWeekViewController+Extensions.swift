//
//  MainWeekViewController+Extensions.swift
//  Budgie
//
//  Created by Chris on 23/02/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import UIKit

// MARK: - UITableViewDelegate
extension MainWeekViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = self.tableView
            .dequeueReusableCell(withIdentifier: CollapsedCell.identifier) as? CollapsedCell
            else { return UITableViewCell() }
        let dataSource = weekDataSource?.days?[indexPath.row]
        let customFilterValue = filterTag(for: dataSource)
        let viewModel = CollapsedCell.ViewModel.init(dataSource,
                                                     delegate: self,
                                                     swipeActions: [.clear],
                                                     filterValueText: customFilterValue)
        cell.viewModel = viewModel
        return cell
    }
    
    func filterTag(for day: LocalDay?) -> String? {
        guard
            let day = day,
            let cells = day.cells,
            let filterValue = self.filterValue
        else {
            return nil
        }
        
        var value: Float = 0.0
        let filteredCells = cells.filter { $0.color == filterValue }
        filteredCells.forEach { value += $0.value }
        return value.asLocaleCurrency
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = MainDayViewController.instantiate() 
            
        guard let day = weekDataSource?.days?[indexPath.row] else { return }
        
        destination.daySelected = day
        destination.viewDelegate = self
        navigationController?.pushViewController(destination, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
}

// MARK: - UITableViewDataSource
extension MainWeekViewController: UITableViewDataSource {}

extension MainWeekViewController: LocalManaging {}

// MARK: - TableViewConfigurable
extension MainWeekViewController: TableViewConfigurable {
    func reloadTable() {
        self.tableView.reloadData()
        self.dateRangeButton.setTitleAs(Date().beginning.returnWeekRange)
    }
}

// MARK: - Filterable
extension MainWeekViewController: Filterable {
    func didSelectColor(_ color: Int?) {
        self.filterValue = color
    }
}
