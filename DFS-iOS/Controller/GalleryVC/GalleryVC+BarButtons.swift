//
//  GalleryVC+BarButtons.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 17.07.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

extension GalleryVC {
    
    //---BarButtonsPressed---//
    //--Upload--//
    /**
     Erzeugt ueber einen Alert den benoetigten ImagePicker und zeigt diesen anschliessend an
     */
    
    
    @IBAction func uploadBarButtonPressed(_ sender: UIBarButtonItem) {
        let imagePickerController = createPicker()
        let alert = createAlert(picker: imagePickerController)
        self.present(alert, animated: true, completion: nil)
    }
    
    //--Download--//
    
    @IBAction func downloadBarButtonPressed(_ sender: UIBarButtonItem) {
        var imagesSaved = 0
        
        
        for cell in galleryCollectionViewCells {
            if cell.isHighlighted {
                if let image = cell.uiImage {
                    
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    imagesSaved += 1
                }
            }
        }
        let alert = UIAlertController(title:"saved", message: "\(imagesSaved) image(s) saved.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "done", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        selectBarButtonPressed(selectBarButton)

    }
    
    //--Trash--//
    
    @IBAction func trashBarButtonPressed(_ sender: UIBarButtonItem) {
        
        var selectedImagesAsString = ""
        var imagesToDelete = 0
        
        for cell in galleryCollectionViewCells {
            if cell.isHighlighted {
                if selectedImagesAsString.count != 0  {
                    selectedImagesAsString += ","
                }
                selectedImagesAsString += (cell.image?.getImageName())!
                imagesToDelete += 1
            }
        }
        
        let alert = UIAlertController(title:"Delete?", message: "Do you really want to delete \(imagesToDelete) image(s)?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "yes", style: .default, handler: { (_) in
            if Communicator.deleteImage(imageNames: selectedImagesAsString){
                self.refreshGallery()
                self.selectBarButtonPressed(self.selectBarButton)
            }
        })
        
        let nopeAction = UIAlertAction(title: "no", style: .default, handler: { (_) in
            self.selectBarButtonPressed(self.selectBarButton)
        })
        
        alert.addAction(okAction)
        alert.addAction(nopeAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //--Select--//
    @IBAction func selectBarButtonPressed(_ sender: UIBarButtonItem) {
        if !highlightingMode {
            selectBarButton.title = "Done"
            self.galleryViewNavigationItem.leftBarButtonItems = [trashBarButton, downloadBarButton]
        }
        else {
            selectBarButton.title = "Select"
            self.galleryViewNavigationItem.leftBarButtonItems = [uploadBarButton]
            for cell in galleryCollectionViewCells {
                cell.isHighlighted = false
                cell.imageSelectedView.isHidden = true
                cell.thumbnail.alpha = 1.0
            }
        }
        highlightingMode = !highlightingMode
    }
    
}
