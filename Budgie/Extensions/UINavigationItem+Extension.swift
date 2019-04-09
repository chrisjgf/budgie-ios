//
//  UINavigation+Extension.swift
//  Budgie
//
//  Created by Chris on 25/03/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import UIKit

extension UINavigationItem{
    func setLabelTitleAs(_ str: String){
        let attributed = NSAttributedString(
            string: str.uppercased(),
            attributes: (
                [NSAttributedString.Key.kern: 1.25,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1)]
            )
        )
        let titleLabel = UILabel()
        titleLabel.attributedText = attributed
        titleLabel.sizeToFit()
        titleView = titleLabel
    }
}
