//
//  CustomCellEdit.swift
//  Budgie
//
//  Created by Chris Fulford on 27/04/2016.
//  Copyright © 2016 Chris Fulford. All rights reserved.
//

import UIKit

class CustomColorsCellEdit: UITableViewCell { // , EditColorsViewDelegate {
    
    static let identifier = "colors_cell"
    static let nib = UINib(nibName: "EditColorsCell", bundle: nil)
    
    @IBOutlet weak var filterView: FilterView!
    
    struct ViewModel {
        var controller: Filterable?
        var cell: Cell?
    }
    
    var viewModel: ViewModel? {
        didSet {
            self.setupUI()
        }
    }
    
    private func setupUI() {
        guard
            let viewModel = self.viewModel,
            let controller = viewModel.controller
        else { return }
        
        self.filterView.delegate = controller
        
        if let cellToEdit = viewModel.cell,
            cellToEdit.color != 0 {
                self.filterView.enableButton(at: Int(cellToEdit.color-1))
            }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .white
        self.selectionStyle = .none
    }
    

    
//    func checkIfValue(){
//        if (cellToEdit != nil){
//            let colorTag: Int = Int(cellToEdit!.color-1)
//            if colorTag >= 0{
//                lastClicked = (colorButtons?[colorTag])!
//                colorButtons?[colorTag].isSelected = true
//            }
//        }
//    }
    
}
