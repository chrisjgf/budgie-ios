//
//  SettingsViewController.swift
//  Budgie
//
//  Created by Chris on 03/05/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import UIKit

class SettingsAboutController: UIViewController {}

// MARK: - StoryboardBased Router
extension SettingsAboutController: StoryboardInstantiatable {
    static var storyboardName: String {
        return "Settings"
    }
    static var navigationTitle: String? {
        return "About"
    }
}
