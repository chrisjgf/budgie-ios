//
//  StoryboardBased.swift
//  Budgie
//
//  Created by Chris on 09/03/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import UIKit

public protocol StoryboardInstantiatable: class {
    static var storyboardName: String { get }
    static var storyboard: UIStoryboard { get }
    static var navigationTitle: String? { get }
}

public extension StoryboardInstantiatable {
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
    }
    static var navigationTitle: String? {
        return nil 
    }
}

public extension StoryboardInstantiatable where Self: UIViewController {
    static func instantiate() -> Self {
        guard
            let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? Self
        else {
            fatalError("The VC of \(storyboard) is not of class \(self)")
        }
        if let navigationTitle = navigationTitle {
            viewController.navigationItem.setLabelTitleAs(navigationTitle)
        }
        return viewController
    }
}
