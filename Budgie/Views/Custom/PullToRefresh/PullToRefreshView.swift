//
//  PullToRefreshConst.swift
//  PullToRefreshSwift
//
//  Created by Yuji Hato on 12/11/14.
//  Qiulang rewrites it to support pull down & push up
//  Further modified to support custom view - Chris

import UIKit

class PullToRefreshView: UIView {

    enum PullToRefreshState {
        case pulling
        case triggered
        case refreshing
        case stop
        case finish
    }
    
    // MARK: Variables
    let contentOffsetKeyPath = "contentOffset"
    let contentSizeKeyPath = "contentSize"
    var kvoContext = "PullToRefreshKVOContext"
    
    private var pull: Bool = true
    private var animationDuration: Double = 0.25
    private var filterView: FilterView
    
    private var positionY:CGFloat = 0 {
        didSet {
            guard self.positionY != oldValue else {
                return
            }
            self.setFrame()
        }
    }
    
    private var state: PullToRefreshState = PullToRefreshState.pulling {
        didSet {
            guard self.state != oldValue else {
                return
            }
            self.setState()
        }
    }
    
    // MARK: UIView
    public override convenience init(frame: CGRect) {
        self.init(frame: frame, animationDuration: 0.25)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(frame: CGRect, animationDuration: Double, controller: Filterable? = nil) {
        filterView = FilterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        filterView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        filterView.delegate = controller
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.05)
        self.addSubview(filterView)
        self.autoresizingMask = .flexibleWidth
    }
    
    override func willMove(toSuperview superView: UIView!) {
        self.removeRegister()
        guard let scrollView = superView as? UIScrollView else {
            return
        }
        scrollView.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .initial, context: &kvoContext)
        if !pull {
            scrollView.addObserver(self, forKeyPath: contentSizeKeyPath, options: .initial, context: &kvoContext)
        }
    }
    
    fileprivate func removeRegister() {
        if let scrollView = superview as? UIScrollView {
            scrollView.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &kvoContext)
            if !pull {
                scrollView.removeObserver(self, forKeyPath: contentSizeKeyPath, context: &kvoContext)
            }
        }
    }
    
    deinit {
        self.removeRegister()
    }
    
    // MARK: KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = object as? UIScrollView else {
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 {
            if scrollView.contentInset.top == self.frame.height
                && !scrollView.isDragging
                && offsetY >= -self.frame.height/1.5
            {
                self.state = .stop
            }

            if offsetY < -self.frame.size.height {
                if scrollView.isDragging == false
                    && self.state != .refreshing
                { // release
                    self.state = .refreshing
                }
            }
            
            let maxHeight = (filterView.frame.size.width/2) / self.frame.height
            
            if offsetY >= -self.frame.height {
                filterView.leftTrailConstaint.constant = filterView.frame.size.width/2 + (offsetY * maxHeight) + 16
                filterView.rightTrailConstraint.constant = filterView.frame.size.width/2 + (offsetY * maxHeight) + 16
            }
        }
        
    }
    
    // MARK: Private Funcs:
    private func setFrame() {
        var frame = self.frame
        frame.origin.y = positionY
        self.frame = frame
    }
    
    private func setState() {
        switch self.state {
        case .stop:
            stopAnimating()
        case .finish:
            var duration = self.animationDuration
            var time = DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.stopAnimating()
            }
            duration = duration * 2
            time = DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.removeFromSuperview()
            }
        case .refreshing:
            startAnimating()
        case .pulling: break
        case .triggered: break
        }
    }
    
    fileprivate func startAnimating() {
        guard let scrollView = superview as? UIScrollView else {
            return
        }
        
        var insets = scrollView.contentInset
        if pull {
            insets.top += self.frame.size.height
        } else {
            insets.bottom += self.frame.size.height
        }
        UIView.animate(
            withDuration: self.animationDuration,
            delay: 0,
            options: [],
            animations: {
                scrollView.contentInset = insets
            }
        )
    }
    
    fileprivate func stopAnimating() {
        guard let scrollView = superview as? UIScrollView else {
            return
        }
        scrollView.bounces = true
        let duration = self.animationDuration
        UIView.animate(
            withDuration: duration,
            animations: {
                scrollView.contentInset = .zero
            }, completion: { _ in
                self.state = .pulling
            }
        ) 
    }
   
}
