//
//  ColorCircle.swift
//  Budgie
//
//  Created by Chris on 27/02/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import UIKit

class ColorCircleButton: UIButton {
    
    // MARK: - Initalisers
    private var miniCircleView: UIView!
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.animateGrow()
            } else {
                self.animateShrink()
            }
        }
    }
    
    // MARK: - Life Cycle:
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    // MARK: - Private Funcs:
    private func setupUI() {
        self.miniCircleView = addMiniCircleView()
        self.addSubview(miniCircleView)
    }
    
    private func addMiniCircleView() -> UIView {
        let minicircle = UIView(frame: self.bounds)
        minicircle.frame.size = CGSize(width: self.frame.size.width/8,
                                       height: self.frame.size.height/8)
        minicircle.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        minicircle.layer.cornerRadius = self.frame.height/2
        minicircle.backgroundColor = .white
        minicircle.alpha = 0
        return minicircle
    }
    
    private func animateGrow() {
        UIView.animate(withDuration: 0.25, animations: {
            self.miniCircleView.alpha = 1
            self.miniCircleView.frame.size = CGSize(width: self.frame.size.width/3,
                                        height: self.frame.size.height/3)
            self.miniCircleView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
            self.miniCircleView.layer.cornerRadius = self.miniCircleView.frame.height/2
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.miniCircleView.frame.size = CGSize(width: self.frame.size.width/4,
                                            height: self.frame.size.height/4)
                self.miniCircleView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
                self.miniCircleView.layer.cornerRadius = self.miniCircleView.frame.height/2
            }
        }
    }
    
    private func animateShrink() {
        UIView.animate(withDuration: 0.25, animations: {
            self.miniCircleView.alpha = 0
            self.miniCircleView.frame.size = CGSize(width: self.frame.size.width/3,
                                        height: self.frame.size.height/3)
            self.miniCircleView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
            self.miniCircleView.layer.cornerRadius = self.miniCircleView.frame.height/2
        })
    }
}
