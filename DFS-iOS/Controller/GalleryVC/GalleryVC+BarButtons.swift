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
            if cell.isSelected {
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
        
        for cell in galleryCollectionViewCells {
            if cell.isSelected {
                if selectedImagesAsString.count != 0  {
                    selectedImagesAsString += ","
                }
                selectedImagesAsString += (cell.image?.getImageName())!
            }
        }
        print(selectedImagesAsString)
        Communicator.deleteImage(imageNames: selectedImagesAsString)
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
                cell.isSelected = false
                cell.imageSelectedView.isHidden = true
                cell.thumbnail.alpha = 1.0
            }
        }
        highlightingMode = !highlightingMode
    }
    
}
