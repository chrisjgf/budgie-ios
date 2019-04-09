//
//  ImageCollectionViewCell.swift
//  Budgie
//
//  Created by Christopher Fulford on 03/09/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var wrapper: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var thumbnailData: NSData? {
        didSet {
            guard let thumbnailData = thumbnailData else { return }
            self.tag = 0
            self.wrapper.backgroundColor = .black
            self.wrapper.layer.borderWidth = 0
            self.imageView.contentMode = UIView.ContentMode.scaleAspectFill
            self.imageView.image = UIImage(data: thumbnailData as Data)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.wrapper.layer.cornerRadius = 3
        self.wrapper.clipsToBounds = true
        
        self.wrapper.layer.borderWidth = 1
        self.wrapper.layer.borderColor = UIColor.tableViewSeparator.cgColor
        self.wrapper.backgroundColor = .white
        let imageOverlay = UIImage(named: "cameraIcon")
        self.imageView.image = imageOverlay
        self.imageView.contentMode = .center
        self.tag = 10
    }
    
    func animate() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.imageView.alpha = 0.75
        }) { (finished) in
            UIView.animate(withDuration: 0.5, animations: {
                self.transform = CGAffineTransform.identity
                self.imageView.alpha = 1
            })
        }
    }
    
}
