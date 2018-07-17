//
//  GalleryVC+ImagePicker.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 17.07.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation
import UIKit

extension GalleryVC: UIImagePickerControllerDelegate {
    /**
     Erzeugt einen ImagePicker
     */
    func createPicker() -> UIImagePickerController{
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        return imagePickerController
    }
    
    /**
     Erzeugt einen UIAlertController, welcher eine Auswahl zwischen Kamera und Galerie bietet
     */
    func createAlert(picker: UIImagePickerController) -> UIAlertController{
        let alert = UIAlertController(title: "Image Source", message: "Please select", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alert
    }
    
    /**
     Wird ausgefuehrt, sobald der ImagePicker ein Bild gepickt hat (entweder ueber Kamera oder als Auswahl in der Galerie)
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
        if var image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            image = image.updateImageOrientionUpSide()!
            let data = UIImagePNGRepresentation(image)
            let imageBase64 = Utils.encodeDataToBase64(data: data!)
            
            let json = "{\n\t\"imageSource\":\"\(imageBase64)\",\n\t\"imageName\":\"\(Utils.generateImageName())\"\n}"
            
            if Communicator.uploadImage(jsonString: json){
                refreshGallery()
            }
            else{
                //Zeige Fehlermeldung in der App
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    /**
     Wenn kein Bild ausgewaehlt wurde, so wird der Picker trotzdem korrekt beendet
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
