//
//  EnlargedImageViewController.swift
//  Budgie
//
//  Created by Christopher Fulford on 04/09/2017.
//  Copyright © 2017 chrisjgf. All rights reserved.
//

import UIKit
import Photos
import MantleModal

class AddImageEnlargedViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveImageButton: UIButton!
    
    // MARK: - Initialisers
    var image: UIImage?
    var imageRef: Image?
    var delegate: RCMantleViewDelegate!
    var cell: Cell?

    // MARK: - View States
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shouldHideStatusBar(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shouldHideStatusBar(false)
    }
    
    // MARK: - Private Funcs:
    private func setupUI(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        delegate.dismissView(true) // Handles the MantleModal view.
        imageView.image = image
    }
    
    // MARK: - @IBActions
    @IBAction func closeTapped() {
        self.dismiss(animated: true)
    }
    
    @IBAction func trashTapped(_ sender: UIButton){
        let alert = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete this image?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { action in
            
            if let img = self.imageRef{
                CoreDataStack.shared.databaseContext.delete(img)
                CoreDataStack.shared.saveContext()
            }
            
            NotificationCenter.default.post(name: .RefreshLocalImages, object: nil, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
    
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func downloadTapped(_ sender: UIButton){
        if saveImageButton.isEnabled{
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: self.image!)
            }, completionHandler: { success, error in
                if success {
                    // Saved successfully!
                    print("Saved!!!")
                }
                else if let _ = error {
                    // Save photo failed with error
                }
                else {
                    // Save photo failed with no error
                }
            })
        }
        
        saveImageButton.setTitle("Image Saved!", for: .normal)
        saveImageButton.isEnabled = false
    }
    
    // MARK: - Methods
    fileprivate func shouldHideStatusBar(_ b: Bool){
        UIView.animate(withDuration: 0.35, animations: ({
            UIApplication.shared.isStatusBarHidden = b
        }))
    }
    
}
