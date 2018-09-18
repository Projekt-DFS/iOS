//
//  GalleryVC+ImagePicker.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 17.07.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation
import UIKit
import ImagePicker
import Photos

extension GalleryVC: ImagePickerDelegate {
    
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        progressView.isHidden = false
        DispatchQueue.global(qos: .userInitiated).async {
            for img in images {
                let data = UIImagePNGRepresentation(img.updateImageOrientionUpSide()!)
                let imageBase64 = Utils.encodeDataToBase64(data: data!)
                
                let json = "{\n\t\"imageSource\":\"\(imageBase64)\",\n\t\"imageName\":\"\(Utils.generateImageName())\"\n}"
                    Communicator.uploadImage(jsonString: json, sender: self)
                DispatchQueue.main.async {
                    self.progressView.progress = self.progressView.progress + Float(1.0 / Double(images.count))
                }
                
            }
            DispatchQueue.main.async {
                imagePicker.dismiss(animated: true, completion: nil)
            }
        }

    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func createImagePicker() {
        var configuration = Configuration()
        configuration.cancelButtonTitle = "Cancel"
        let imagePickerController = ImagePickerController(configuration: configuration)
        imagePickerController.delegate = self
        
        initializeProgressView()
        imagePickerController.view.addSubview(progressView)
        
        present(imagePickerController, animated: true, completion: nil)

    }
    
    func initializeProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .white
        progressView.trackTintColor = .black
        
        progressView.progress = 0.0
        progressView.layer.zPosition = 100
        progressView.layer.borderColor = UIColor.white.cgColor
        progressView.layer.borderWidth = 0.07
        progressView.isHidden = true
        
        
        let transform = CGAffineTransform(scaleX: 4.0, y: 5.0)
        progressView.transform = transform
        progressView.center = view.center
    }
    

}
