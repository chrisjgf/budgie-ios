//
//  CustomCellTableViewCell.swift
//  Budgie
//
//  Created by Chris on 20/12/2016.
//  Copyright © 2016 chrisjgf. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ExpandedCell: MGSwipeTableCell  {
    
    static let nib = UINib(nibName: "ExpandedCell", bundle: nil)
    static let identifier = "cellExpanded"
    
    struct ViewModel {
        var delegate: TableViewConfigurable?
        var dataSource: Cell?
        var swipeActions: [SwipeButtonState]?
        
        init(_ dataSource: Cell?,
             delegate: TableViewConfigurable?,
             swipeActions: [SwipeButtonState]? = nil)
        {
            self.delegate = delegate
            self.dataSource = dataSource
            self.swipeActions = swipeActions
        }
    }

    // MARK: - @IBOutlets:
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: PaddingLabel!
    @IBOutlet weak var attachImage: UIImageView!
    
    // MARK: - Initialisers:
    var viewModel: ViewModel? {
        didSet {
            self.setupUI()
        }
    }
    var images: NSSet? {
        didSet {
            self.determineAttachment()
        }
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.adjustLabelsForiPhonePlus()
    }
    
    // MARK: - Private Funcs:
    private func setupUI() {
        self.value.data = viewModel?.dataSource
        self.title.text = viewModel?.dataSource?.title ?? "No expenses found"
        self.images = viewModel?.dataSource?.images
        self.accessoryType = viewModel?.dataSource != nil ? .disclosureIndicator : .none
        if viewModel != nil { self.setupSwipeActions() }
    }
    
    private func setupSwipeActions() {
        guard let swipeActions = self.viewModel?.swipeActions else { return }
        
        var swipeViews: [UIView] = []
        for action in swipeActions {
            swipeViews.append(MGSwipeButton(title: "", icon: action.image, backgroundColor: .white, callback:
                { (sender: MGSwipeTableCell!) -> Bool in
                    self.viewModel?.delegate?.swipeActionTapped(self, action: action)
                    return true
            }))
        }
        self.rightButtons = swipeViews
        self.rightSwipeSettings.transition = .drag
    }
    
    private func determineAttachment() {
        guard
            let images = images,
            images.count > 0
        else {
            self.attachImage.isHidden = true
            return
        }
        self.attachImage.isHidden = false
    }
    
    private func adjustLabelsForiPhonePlus() {
        if DeviceType.isiPhone6P {
            value.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.light)
            title.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.light)
        }
    }
}

