//
//  AddEditViewController+Extensions.swift
//  Budgie
//
//  Created by Chris on 26/02/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import UIKit

// MARK: - UITableViewDelegate
extension AddEditViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: SettingsTableHeader.identifier)
            as? SettingsTableHeader else { return UIView() }
        headerView.title.attributedText = headerTitles[section].uppercased().withKern(1.25)
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSection = dataSource?[section] else { return 0 }
        return dataSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = dataSource?[indexPath.section][indexPath.row] else { return UITableViewCell() }
        switch viewModel {
        case is CustomCellEdit.ViewModel:
            guard let cell = self.tableView
                .dequeueReusableCell(withIdentifier: CustomCellEdit.identifier)
                as? CustomCellEdit else { return UITableViewCell() }
            cell.viewModel = viewModel as? CustomCellEdit.ViewModel
            return cell
        case is CustomColorsCellEdit.ViewModel:
            guard let cell = self.tableView
                .dequeueReusableCell(withIdentifier: CustomColorsCellEdit.identifier)
                as? CustomColorsCellEdit else { return UITableViewCell() }
            cell.viewModel = viewModel as? CustomColorsCellEdit.ViewModel
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        switch cell {
        case is CustomCellEdit:
            guard let cell = cell as? CustomCellEdit else { return }
            if cell.viewModel!.state != .image {
                cell.valueTextField.becomeFirstResponder()
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
                routeToImageView()
            }
        default:
            return
        }
    }
}

extension AddEditViewController: UITableViewDataSource {}

extension AddEditViewController: StoryboardInstantiatable {
    static var storyboardName: String {
        return "Add"
    }
}

extension AddEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let decimalRange = textField.text?.range(of: ".", options: NSString.CompareOptions.literal, range: nil, locale: nil)
        if decimalRange?.isEmpty == false && string == "." {
            return false
        }
        let commaRange = textField.text?.range(of: ",", options: NSString.CompareOptions.literal, range: nil, locale: nil)
        if commaRange?.isEmpty == false && string == "," {
            return false
        }
        return true
    }
}

extension AddEditViewController: Filterable {
    func didSelectColor(_ color: Int?) {
        self.selectedColor = color
    }
}

extension AddEditViewController: DataManaging {}
