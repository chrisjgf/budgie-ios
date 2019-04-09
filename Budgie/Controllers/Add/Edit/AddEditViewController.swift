//
//  AddEditViewController.swift
//  Budgie
//
//  Created by Chris on 23/12/2016.
//  Copyright © 2016 chrisjgf. All rights reserved.
//

import UIKit
import CoreData

class AddEditViewController: UIViewController, TableViewConfigurable {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabelButton: UIButton!

    // MARK: - Initialisers
    var daySelected: LocalDay?
    var cellToEdit: Cell?
    var viewDelegate: TableViewConfigurable?
    var selectedDate: Date? // picker date value
    var selectedIndexDate: Date? // selected section date value
    var selectedColor: Int?
    var headerTitles: [String] {
        return ["Details", "Tag", "Attachment"]
    }
    var dataSource: [[Any]]? {
        return self.returnDataForSections()
    }
    var isEditingCell: Bool {
        return cellToEdit != nil
    }
    
    // MARK: - @IBActions:
    @IBAction func navLeftButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func navRightButtonTapped() {
        self.saveExpense()
    }
    
    @IBAction func dateSelectorTapped() {
        print("change date")
    }

    // MARK: - View Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Private Funcs:
    private func setupUI() {
        self.setupNavigation()
        self.setupDateLabel()
        self.setupTableView()
        self.setupKeyboardNotifications()
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.applyDefaultTheme()
    }
    
    private func setupDateLabel() {
        let date = daySelected?.date ?? Date()
        self.dateLabelButton.setTitleAs(date.asDayDateMonth.uppercased())
    }
    
    private func setupTableView(){
        self.tableView.register(SettingsTableHeader.nib,
                           forHeaderFooterViewReuseIdentifier: SettingsTableHeader.identifier)
        self.tableView.register(CustomCellEdit.nib,
                           forCellReuseIdentifier: CustomCellEdit.identifier)
        self.tableView.register(CustomColorsCellEdit.nib,
                           forCellReuseIdentifier: CustomColorsCellEdit.identifier)

        self.tableView.rowHeight = self.rowHeight
        self.tableView.layoutMargins = .zero
        self.tableView.separatorInset = .zero
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.tableViewSeparator
    }
    
    private func setupKeyboardNotifications(){
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    // MARK: - Public Funcs:
    
    // MARK: - Table View
    private func returnDataForSections() -> [[Any]] {
        return [
            [CustomCellEdit.ViewModel.init(state: .title, cellToEdit),
             CustomCellEdit.ViewModel.init(state: .price, cellToEdit)],
            [CustomColorsCellEdit.ViewModel.init(controller: self, cell: cellToEdit)],
            [CustomCellEdit.ViewModel.init(state: .image, nil)]
        ]
    }
    
    private func updateExpense(for cell: Cell,
                               _ title: String,
                               _ value: String) {
        let value = Float(value)
        cell.title = title == "" ? cell.title : title
        cell.value = value == nil ? cell.value : value!
        cell.date = self.daySelected?.date ?? Date()
        cell.id = NSDate().timeIntervalSince1970
        cell.color = Int16(self.selectedColor ?? 0)
    }
    
    private func saveAndReloadTable() {
        CoreDataStack.shared.saveContext()
        self.viewDelegate?.reloadTable()
        self.dismiss(animated: true, completion: nil)
    }
    
    // FIXME: - change in getting data
    private func saveExpense() {
        guard
            let title = (self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
                as? CustomCellEdit)?.valueTextField.text,
            let value = (self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))
                as? CustomCellEdit)?.valueTextField.text
        else {
            return
        }

        var cell = self.cellToEdit
        if !isEditingCell {
            cell = self.createExpense(for: daySelected?.date)
        }
        
        if let cell = cell {
            self.updateExpense(for: cell, title, value)
            self.saveAndReloadTable()
        }
    }
    
    // MARK: - Methods
    func routeToImageView(){
        let controller = AddImageCollectionViewController.instantiate()
        controller.cell = cellToEdit
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func keyboardWillShow(sender: Notification) {
        guard let keyboardSize = sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else{
            return
        }
        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardSize.cgRectValue.height, right: 0)
    }
    
    @objc func keyboardWillHide(sender: Notification) {
        self.tableView.contentInset = UIEdgeInsets.zero
    }
    
}
