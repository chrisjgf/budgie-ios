//
//  UIButton+Extensions.swift
//  Budgie
//
//  Created by Chris on 25/03/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import UIKit

extension UIButton {
    func setTitleAs(_ str: String) {
        let attributedText =  NSAttributedString(string: str.uppercased(),
                                                 attributes: (
                                                    [NSAttributedString.Key.kern: 1.25,
                                                     NSAttributedString.Key.font: self.titleLabel!.font,
                                                     NSAttributedString.Key.foregroundColor: self.titleLabel!.textColor]))
        self.setAttributedTitle(attributedText, for: .normal)
    }
}
