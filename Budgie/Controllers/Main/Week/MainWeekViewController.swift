//
//  ViewController.swift
//  Budgie
//
//  Created by Chris on 20/12/2016.
//  Copyright © 2016 chrisjgf. All rights reserved.
//

import UIKit
import CoreData

class MainWeekViewController: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateRangeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Initialisers
    var weekDataSource: LocalWeek? {
        return self.createLocalWeek(from: Date())
    }
    var filterValue: Int? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var defaultWeekday: Int {
        return UserDefaults.standard.integer(forKey: "WeekdaySettings")
    }
    var defaultPickerDate = Date()
    
    // MARK: - @IBActions:
    @IBAction func settingsTapped(_ sender: AnyObject) {
        self.presentSettings()
    }
    
    @IBAction func calendarTapped(_ sender: AnyObject){
        self.presentCalendarModal()
    }
    
    // MARK: - View Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadTable()
    }
    
    // MARK: - Public Funcs:
    func handleSwipeAction(for indexPath: IndexPath, _ action: SwipeButtonState) {
        switch action {
        case .clear:
            guard let dayToDelete = self.weekDataSource?.days?[indexPath.row] else { return }
            self.deleteManagedObject(dayToDelete.db)
            self.reloadTable()
        default:
            return
        }
    }
    
    // MARK: - Private Funcs:
    private func setupUI() {
        self.setupNavigation()
        self.setupTableView()
        self.setupLabels()
    }
    
    private func setupNavigation() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.applyDefaultTheme()
    }
    
    private func setupTableView() {
        self.tableView.register(CollapsedCell.nib, forCellReuseIdentifier: CollapsedCell.identifier)
        self.tableView.layoutMargins = .zero
        self.tableView.separatorInset = .zero
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.tableViewSeparator
        self.tableView.rowHeight = self.rowHeight
        self.addPullRefresh(to: tableView, options: PullToRefreshConst())
    }
    
    private func setupLabels() {
        self.titleLabel.text = weekDataSource?.value.asLocaleCurrency
        self.dateRangeButton.setTitleAs(Date().beginning.returnWeekRange)
    }
    
    // MARK: - Router Funcs:
    private func presentSettings() {
        let controller = SettingsViewController.instantiate() 
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true)
    }
    
    private func presentCalendarModal() {
        print("Present calendar modal")
    }
}
