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
       
        for img in images {
            let data = UIImagePNGRepresentation(img.updateImageOrientionUpSide()!)
            let imageBase64 = Utils.encodeDataToBase64(data: data!)
            
            let json = "{\n\t\"imageSource\":\"\(imageBase64)\",\n\t\"imageName\":\"\(Utils.generateImageName())\"\n}"
            
            DispatchQueue.global(qos: .userInitiated).async {
                Communicator.uploadImage(jsonString: json, sender: self)
            }
        }

        collectionView?.alpha = 0.3
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func createImagePicker() {
        var configuration = Configuration()
        configuration.cancelButtonTitle = "Cancel"
        let imagePickerController = ImagePickerController(configuration: configuration)
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    

}
