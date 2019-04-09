//
//  AddImageCollectionViewController+Extensions.swift
//  Budgie
//
//  Created by Chris on 24/03/2019.
//  Copyright © 2019 chrisjgf. All rights reserved.
//

import UIKit

extension AddImageCollectionViewController: StoryboardInstantiatable {
    static var storyboardName: String {
        return "Add"
    }
    static var navigationTitle: String? {
        return "Image"
    }
}

extension AddImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        let widthAvailbleForAllItems =  (collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right)
        var numberOfColumns: CGFloat = 3
        if DeviceType.isiPhone5 {
            numberOfColumns = 2
        }
        let widthForOneItem = widthAvailbleForAllItems / numberOfColumns - flowLayout.minimumInteritemSpacing
        return CGSize(width: CGFloat(widthForOneItem), height: CGFloat(widthForOneItem*1.5))
    }
}
extension AddImageCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate { }
