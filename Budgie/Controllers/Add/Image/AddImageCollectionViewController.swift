//
//  ImageCollectionViewController.swift
//  Budgie
//
//  Created by Christopher Fulford on 02/02/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import UIKit
import CoreData
import MantleModal

class AddImageCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Initialisers
    var cell: Cell?
    var cellImages: [Image]? {
        return returnCellImages()
    }
    var lastImageSelected: UIImage?
    var isNewCell: Bool {
        return (cell != nil)
    }
    var imagePicker: UIImagePickerController!
    
    // MARK: - View States
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func returnCellImages() -> [Image]? {
        guard
            let cell = cell,
            (cell.images?.count ?? 0) > 0
        else { return nil }
        return cell.images?.sortedArray(using: [NSSortDescriptor(key: "id",
                                                                 ascending: true)]) as? [Image] ?? nil
    }
    
    // MARK: - Collection View
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return (cellImages?.count ?? 0) + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell)?.animate()
        self.determineSelectionAction(indexPath)
    }
    
    private func determineSelectionAction(_ indexPath: IndexPath) {
        if indexPath.row != cellImages?.count && cellImages != nil {
            self.presentImage(indexPath)
        } else {
            self.attachImageAction()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell",
                                                      for: indexPath) as! ImageCollectionViewCell
        guard
            indexPath.row != cellImages?.count,
            let cellThumbnail = self.cellImages?[indexPath.row].thumbnailData
        else {
            return cell
        }
        cell.thumbnailData = cellThumbnail as NSData
        return cell
    }
    
    // MARK: - Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        self.saveImage(image: image)
        self.collectionView?.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func attachImageAction() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        })
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:{})
    }
    
    // MARK: - Methods
    private func setupUI(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLocal), name: .RefreshLocalImages, object: nil)
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
    }
    
    @objc func refreshLocal(){
        collectionView?.reloadData()
    }
    
    fileprivate func saveImage(image: UIImage) {
        guard
            let fullsizeData: Data = image.jpegData(compressionQuality: 1) as Data?,
            let thumbnailData: Data = image.cropToCenter.jpegData(compressionQuality: 0.01) as Data?,
            let image = NSEntityDescription.insertNewObject(forEntityName: "Image",
                                                            into: CoreDataStack.shared.databaseContext) as? Image
        else{
            print("jpg error")
            return
        }
        
        image.fullsizeData = fullsizeData
        image.thumbnailData = thumbnailData
        image.id = NSDate().timeIntervalSince1970
        
        if let cell = cell {
            image.cell = cell
        }
        
        CoreDataStack.shared.saveContext()
    }
    
    fileprivate func presentImage(_ index: IndexPath){
        let mantleViewController = storyboard!.instantiateViewController(withIdentifier: "MantleViewController") as! RCMantleViewController
        let popUpViewController = storyboard!.instantiateViewController(withIdentifier: "enlargedImage") as! AddImageEnlargedViewController
        
        guard let fullSizeImage = cellImages?[index.row].fullsizeData else { return }
        
        popUpViewController.delegate = mantleViewController
        popUpViewController.cell = cell
        popUpViewController.imageRef = cellImages?[index.row]
        popUpViewController.image = UIImage(data: fullSizeImage as Data)
        
        mantleViewController.bottomDismissible = false
        mantleViewController.topDismissable = true
        mantleViewController.draggableToSides = true
        mantleViewController.appearOffset = CGFloat(390)
        mantleViewController.appearFromTop = true // // default = false
        mantleViewController.setUpScrollView()
        mantleViewController.addToScrollViewNewController(popUpViewController)

        self.present(mantleViewController, animated: false, completion: nil)
    }

}
