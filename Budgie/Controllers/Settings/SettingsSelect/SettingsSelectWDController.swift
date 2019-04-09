//
//  SettingsViewController.swift
//  Budgie
//
//  Created by Chris on 03/05/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import UIKit

class SettingsSelectWDController: UIViewController, TableViewConfigurable {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Initialisers
    var dataSource: [String] {
        return ["Saturday", "Sunday", "Monday"]
    }
    
    // MARK: - View States
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    // MARK: - Private Funcs:
    private func setupTableView(){
        self.tableView.register(SettingsCellTitle.nib,
                                forCellReuseIdentifier: SettingsCellTitle.identifier)
        self.tableView.rowHeight = self.rowHeight
        self.tableView.layoutMargins = .zero
        self.tableView.separatorInset = .zero
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.tableViewSeparator
    }
}

// MARK: - StoryboardBased for easy routing
extension SettingsSelectWDController: StoryboardInstantiatable {
    static var navigationTitle: String? {
        return "Week Start Day"
    }
    static var storyboardName: String {
        return "Settings"
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsSelectWDController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCellTitle = self.tableView.dequeueReusableCell(withIdentifier: "cellSettingsTitle") as! SettingsCellTitle
        cell.title = dataSource[indexPath.row]
        cell.index = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "WeekdaySettings")
        navigationController?.popViewController(animated: true)
    }
}
