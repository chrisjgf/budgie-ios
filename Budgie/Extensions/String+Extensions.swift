//
//  String+Extensions.swift
//  Budgie
//
//  Created by Chris on 25/03/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import UIKit

extension String {
    func withKern(_ amount: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.kern,
                                      value: amount,
                                      range: NSRange(location: 0,
                                                     length: self.count))
        return attributedString
    }
}
