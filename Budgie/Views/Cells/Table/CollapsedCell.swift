//
//  CustomCellTableViewCell.swift
//  Budgie
//
//  Created by Chris on 20/12/2016.
//  Copyright © 2016 chrisjgf. All rights reserved.
//

import UIKit
import MGSwipeTableCell

enum SwipeButtonState: String {
    case clear, delete, edit
    var image: UIImage? {
        return UIImage(named: String(describing: self))
    }
}

class CollapsedCell: MGSwipeTableCell  {
    
    static let identifier = "CollapsedCell"
    static let nib = UINib(nibName: "CollapsedCell", bundle: nil)
    
    // MARK: - View Model
    struct ViewModel {
        var delegate: TableViewConfigurable?
        var dataSource: LocalDay?
        var swipeActions: [SwipeButtonState]?
        var filterValueText: String?
        
        init(_ dataSource: LocalDay?,
             delegate: TableViewConfigurable?,
             swipeActions: [SwipeButtonState]? = nil,
             filterValueText: String? = nil)
        {
            self.delegate = delegate
            self.dataSource = dataSource
            self.swipeActions = swipeActions
            self.filterValueText = filterValueText
        }
    }
    
    // MARK: - @IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: PaddingLabel!
    
    // MARK: - Intialisers
    var viewModel: ViewModel? {
        didSet {
            self.setupUI()
        }
    }
    
    // MARK: - Life Cycle:
    override func awakeFromNib() {
        super.awakeFromNib()
        self.adjustLabelsForiPhonePlus()
    }
    
    // MARK: - Private Funcs:
    private func setupUI() {
        guard
            let viewModel = viewModel,
            let localDay = viewModel.dataSource
            else { return }
        self.titleLabel.text = localDay.date.dayOfWeek
        self.dateLabel.text = localDay.date.asSingleValue
        self.valueLabel.text = (localDay.value > 0) ? localDay.value.asLocaleCurrency : nil
        if let filterValueText = viewModel.filterValueText {
            self.valueLabel.text = filterValueText
        }
        self.setupValueLabelAppearance()
        self.setupSwipeActions()
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
    
    private func adjustLabelsForiPhonePlus() {
        if DeviceType.isiPhone6P {
            valueLabel.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.light)
            dateLabel.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.light)
            titleLabel.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.light)
        }
    }
    
    private func setupValueLabelAppearance(){
        guard
            let localDay = viewModel?.dataSource,
            let dateYesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        else { return }
        
        if localDay.date < Date() {
            self.dateLabel.alpha = 0.5
            if localDay.date > dateYesterday {
                self.dateLabel.textColor = UIColor(red: 211/255, green: 15/255, blue: 39/255, alpha: 1)
                self.dateLabel.alpha = 1
            } else {
                self.dateLabel.textColor = .black
            }
        } else {
            self.dateLabel.alpha = 1
            self.dateLabel.textColor = .black
        }
    }
}
