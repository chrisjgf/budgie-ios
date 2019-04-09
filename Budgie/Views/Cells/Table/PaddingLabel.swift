//
//  PaddingLabel.swift
//  Budgie
//
//  Created by Chris on 24/12/2016.
//  Copyright © 2016 chrisjgf. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    
    public var color: Int16 = 0 {
        didSet {
            let color = determineBackground()
            self.backgroundColor = color
        }
    }

    // Adds padding to the title_2 label.
    override var intrinsicContentSize : CGSize {
        self.sizeToFit()
        frame = frame.insetBy(dx: -7, dy: -2)
        let size = frame.size
        
        layer.cornerRadius = 10 // was 6
        layer.masksToBounds = true;
        
        return size
    }

    private func determineBackground() -> UIColor {
        switch color {
        case 1: // red
            return UIColor(red: 255/255.0, green: 64/255.0, blue: 64/255.0, alpha: 0.5)
        case 2: // green
            return UIColor(red: 96/255.0, green: 255/255.0, blue: 64/255.0, alpha: 0.5)
        case 3: // blue
            return UIColor(red: 64/255.0, green: 191/255.0, blue: 255/255.0, alpha: 0.5)
        case 4: // yellow
            return UIColor(red: 255/255.0, green: 239/255.0, blue: 64/255.0, alpha: 0.5)
        case 5: // magenta
            return UIColor(red: 255/255.0, green: 64/255.0, blue: 255/255.0, alpha: 0.5)
        default: // grey
            return UIColor.black.withAlphaComponent(0.05)
        }
    }
    
    public var data: Cell? {
        didSet{
            if let data = data {
                color = data.color
                text = data.value.asLocaleCurrency
            } else {
                text = ""
            }
        }
    }
    
    override var text: String? {
        didSet {
            if text != nil, color == 0 {
                backgroundColor = UIColor.black.withAlphaComponent(0.05)
            }
        }
    }
    
}
