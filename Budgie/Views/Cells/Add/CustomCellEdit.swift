//
//  CustomCellEdit.swift
//  Budgie
//
//  Created by Chris Fulford on 27/04/2016.
//  Copyright © 2016 Chris Fulford. All rights reserved.
//

import UIKit

class CustomCellEdit: UITableViewCell {
    
    static let identifier = "cell"
    static let nib = UINib(nibName: "EditCell", bundle: nil)

    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    
    enum RowState: String {
        case title, price, image
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .price:
                return .decimalPad
            default:
                return .default
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .title:
                return UIImage(named: "descriptionIcon")
            case .price:
                return UIImage(named: "valueIcon")
            case .image:
                return UIImage(named: "cameraIcon")
            }
        }
    }
    
    struct ViewModel {
        var state: RowState
        var cellToEdit: Cell?
        
        init(state: RowState, _ cellToEdit: Cell?) {
            self.state = state
            self.cellToEdit = cellToEdit
        }
    }
    
    var viewModel: ViewModel? {
        didSet {
            self.setupUI()
        }
    }

    
    private func setupUI() {
        guard let viewModel = viewModel else { return }
        self.valueTextField.keyboardType = viewModel.state.keyboardType
        self.iconImageView.image = viewModel.state.iconImage
        self.valueTextField.isEnabled = viewModel.state != .image
        self.accessoryType = (viewModel.state != .image) ? .none : .disclosureIndicator

        if let cellToEdit = viewModel.cellToEdit {
            switch viewModel.state {
            case .title:
                self.valueTextField.placeholder = cellToEdit.title ?? "???"
            case .price:
                self.valueTextField.placeholder = cellToEdit.value.asLocaleCurrency
            default:
                return
            }
        } else {
            self.valueTextField.placeholder = String(describing: viewModel.state).capitalized
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        // FIXME: - iPhone Plus font size
        if DeviceType.isiPhone6P {
            if #available(iOS 8.2, *) {
                valueTextField.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.light)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
