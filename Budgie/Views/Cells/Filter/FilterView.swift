//
//  FilterView.swift
//  Budgie
//
//  Created by Christopher Fulford on 03/03/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import UIKit

extension Filterable where Self: UIViewController {
    func addPullRefresh(to tableView: UITableView,
                        options: PullToRefreshConst)
    {
        let refreshViewFrame = CGRect(x: 0, y: -options.height,
                                      width: self.view.frame.size.width,
                                      height: options.height)
        let refreshView = PullToRefreshView(frame: refreshViewFrame,
                                            animationDuration: options.animationDuration,
                                            controller: self)
        tableView.addSubview(refreshView)
    }
}

protocol Filterable {
    func didSelectColor(_ color: Int?)
    func addPullRefresh(to tableView: UITableView, options: PullToRefreshConst)
}

class FilterView: UIView  {
    
    // MARK: - @IBOutlets
    @IBOutlet var circleButtons: [ColorCircleButton]!
    @IBOutlet weak var leftTrailConstaint: NSLayoutConstraint!
    @IBOutlet weak var rightTrailConstraint: NSLayoutConstraint!
    
    var view: UIView!
    var lastButton: UIButton?
    var delegate: Filterable? 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "FilterView", bundle: bundle)
        
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func xibSetUp() {
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        
        for button in circleButtons {
            button.layer.cornerRadius = button.frame.height/2
            button.clipsToBounds = true
            
            // Add mini circle
            let minicircle = UIView(frame: button.bounds)
            minicircle.frame.size = CGSize(width: button.frame.size.width/8,
                                           height: button.frame.size.height/8)
            minicircle.center = CGPoint(x: button.frame.size.width/2, y: button.frame.size.height/2)
            minicircle.layer.cornerRadius = minicircle.frame.height/2
            minicircle.backgroundColor = UIColor.white
            minicircle.tag = 7
            minicircle.alpha = 0
            button.addSubview(minicircle)
        }
    }
    
    func enableButton(at index: Int) {
        self.circleButtons[index].isSelected = true
        self.lastButton = circleButtons[index]
    }
    
    @IBAction func color(_ sender: ColorCircleButton) {
        defer { delegate?.didSelectColor(sender.tag) }
        guard let lastButton = self.lastButton else {
            self.lastButton = sender
            sender.isSelected = !sender.isSelected
            return
        }

        if (lastButton != sender) && !sender.isSelected {
            lastButton.isSelected = false
        }
    
        sender.isSelected = !sender.isSelected
        self.lastButton = sender
    }
    
}
