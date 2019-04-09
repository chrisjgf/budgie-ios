//
//  ViewController.swift
//  Budgie
//
//  Created by Chris on 20/12/2016.
//  Copyright © 2016 chrisjgf. All rights reserved.
//

import UIKit
import CoreData

class MainDayViewController: UIViewController, TableViewConfigurable {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateRangeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Initialisers
    var viewDelegate: TableViewConfigurable? // ViewController Delegate
    var daySelected: LocalDay!
    
    // MARK: - @IBActions
    @IBAction func addNew(_ sender: AnyObject) {
        self.presentAddVC()
    }
    
    // MARK: - View Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Public Funcs:
    func handleSwipeAction(for indexPath: IndexPath, _ action: SwipeButtonState) {
        switch action {
        case .edit:
            self.presentAddVC(indexPath)
        case .delete:
            self.deleteSelected(indexPath)
        default:
            return
        }
    }

    // MARK: - Router Funcs:
    func presentAddVC(_ indexPath: IndexPath? = nil) {
        let controller = AddEditViewController.instantiate()
        controller.viewDelegate = self
        controller.daySelected = self.daySelected
        if let cells = self.daySelected.cells, // Present w/ edit
            let indexPath = indexPath {
            controller.cellToEdit = cells[indexPath.row]
        }
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true)
    }
    
    // MARK: - Private Funcs:
    private func setupUI() {
        self.setupTitleLabel()
        self.setupTableView()
        self.setupNavigationTitle()
    }
    
    private func setupNavigationTitle() {
        guard let date = daySelected?.date else { return }
        self.dateRangeButton.setTitleAs(date.asDayDateMonth.uppercased())
    }
    
    private func setupTitleLabel() {
        self.titleLabel.text = daySelected.value.asLocaleCurrency
    }
    
    private func setupTableView() {
        self.tableView.register(ExpandedCell.nib, forCellReuseIdentifier: ExpandedCell.identifier)
        self.tableView.layoutMargins = .zero
        self.tableView.separatorInset = .zero
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = self.rowHeight
        self.tableView.separatorColor = UIColor.tableViewSeparator
    }
    
    private func deleteSelected(_ index: IndexPath) {
        guard let cells = self.daySelected.cells else { return }
        self.deleteManagedObject(cells[index.row])
        self.reloadTable()
    }
    
    fileprivate func reloadTitle(with value: Float?) {
        guard let value = value else {
            self.titleLabel.attributedText = daySelected?.db?.value.asLocaleCurrency.withKern(1.25)
            return
        }
        self.titleLabel.attributedText = value.asLocaleCurrency.withKern(1.25)
    }
  
    func reloadTable() {
        self.daySelected.refresh()
        self.titleLabel.text = daySelected.value.asLocaleCurrency
        self.tableView.reloadData()
    }
    
    /*
    @IBAction func changeDate(_ sender: AnyObject){
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: defaultPickerDate, maximumDate: Date(), datePickerMode: .dateAndTime) {
            (date) -> Void in
            if let d = date{
                self.defaultPickerDate = d
                
                let beginning = d.findStartDate
                
                self.cellsForWeek = dataBridge.returnWeek(withDate: beginning)
                self.dateRangeButton.setTitleAs(beginning.returnWeekRange)
                
                self.tableView.reloadData()
                self.reloadTitle()
            }
        }
    }*/
}


