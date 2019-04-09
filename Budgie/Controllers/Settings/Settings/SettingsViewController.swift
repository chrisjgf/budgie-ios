//
//  SettingsViewController.swift
//  Budgie
//
//  Created by Chris on 03/05/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import UIKit
import MessageUI

extension SettingsViewController: StoryboardInstantiatable {
    static var storyboardName: String {
        return "Settings"
    }
    static var navigationTitle: String? {
        return "Settings"
    }
}

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    // MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - @IBActions
    @IBAction func navigationButtonTapped() {
        self.dismiss(animated: true)
    }

    // MARK: - Initialisers
    var settings: [Setting] {
        return [
            Setting(title: "Data", rowTitles: ["Export data"]),
            Setting(title: "Settings", rowTitles: ["Start of the week"]),
            Setting(title: "Help", rowTitles: ["About", "Report a bug"])
        ]
    }
    
    // MARK: - View States
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Private Funcs:
    private func setupUI() {
        self.setupTableView()
        self.setupNavigation()
    }

    // MARK: - Methods
    private func setupTableView(){
        self.tableView.register(SettingsTableHeader.nib,
                                forHeaderFooterViewReuseIdentifier: SettingsTableHeader.identifier)
        self.tableView.register(SettingsCellTitle.nib,
                                forCellReuseIdentifier: SettingsCellTitle.identifier)
        self.tableView.rowHeight = 64.0
        self.tableView.sectionHeaderHeight = 2*(64.0/3)
        self.tableView.layoutMargins = .zero
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.tableViewSeparator
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.applyDefaultTheme()
    }
    
    fileprivate func sendEmail() {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        let device = UIDevice.current.modelName
        let sysVersion = UIDevice.current.systemVersion
    
        let composer = MFMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            composer.mailComposeDelegate = self
            composer.setToRecipients(["budgie@chrisjgf.com"])
            composer.setSubject("Bug - Budgie")
            composer.setMessageBody("My device is \(device) (\(sysVersion)) running Budgie \(appVersion).\n\n ", isHTML: false)
            present(composer, animated: true, completion: nil)
        }
    }
    
    fileprivate func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func presentModal(for path: URL?) {
        guard let path = path else { return }
        let activityVC = UIActivityViewController(activityItems: [path], applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
        self.present(activityVC, animated: true, completion: nil)
    }
    
    fileprivate func dataExportToCSV() -> URL? {
        guard let cells = self.fetchManagedObjects(for: .day) as? [Cell] else {
            return nil
        }
        var csvData = [CSVItem]()
        for cell in cells {
            let csvItem = CSVItem(date: cell.date! as Date,
                                  title: cell.title,
                                  value: cell.value)
            csvData.append(csvItem)
        }
        let currencySymbol = (Locale.current).currencySymbol ?? ""
        let csvExportPath = self.createCSV(for: csvData,
                                       header: "Date,Description,Value (\(currencySymbol))\n")
        return csvExportPath
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].rowTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView
            .dequeueReusableCell(withIdentifier: SettingsCellTitle.identifier) as? SettingsCellTitle else {
            return UITableViewCell()
        }
        cell.titleLabel.text = settings[indexPath.section].rowTitles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.section {
        case 0: // Export Data
            let csvURL = self.dataExportToCSV()
            self.presentModal(for: csvURL)
        case 1: // Start of the week
            let controller = SettingsSelectWDController.instantiate()
            self.navigationController?.pushViewController(controller, animated: true)
        case 2:
            switch indexPath.row {
            case 0:
                let controller = SettingsAboutController.instantiate()
                self.navigationController?.pushViewController(controller, animated: true)
            case 1:
                sendEmail()
            default:
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsTableHeader") as! SettingsTableHeader
        cell.title.attributedText = settings[section].title.uppercased().withKern(1.25)
        return cell
    }
}

extension SettingsViewController: DataManaging {} 
extension SettingsViewController: Exportable {}
