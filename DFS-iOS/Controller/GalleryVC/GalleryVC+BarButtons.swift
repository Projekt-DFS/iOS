import UIKit

/// Extension to GalleryVC to manage all actions belonging to bar buttons.
///
/// - author: Phillip Persch
extension GalleryVC {
    
    /// Gets called when the user presses the upload bar button.
    /// It calls the createImagePicker function, which handles the selection of images to upload.
    ///
    /// - parameter sender: the bar button that was pressed
    @IBAction func uploadBarButtonPressed(_ sender: UIBarButtonItem) {
        createImagePicker()        
    }
    

    /// Gets called when the user presses the download bar button.
    /// Saves the selected album to the device's storage and makes it available from the Photos app
    ///
    /// - parameter sender: the bar button that was pressed
    @IBAction func downloadBarButtonPressed(_ sender: UIBarButtonItem) {
        var imagesSaved = 0
        
        print(galleryCollectionView.visibleCells.count)
        for cell in galleryCollectionView.visibleCells as! [GalleryCollectionViewCell] {
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
    
    /// Gets called when the user presses the trash bar button.
    /// Deletes the selected items from the backend.
    /// Lets the user confirm the action before performing it.
    ///
    /// - parameter sender: the bar button that was pressed
    @IBAction func trashBarButtonPressed(_ sender: UIBarButtonItem) {
        
        var selectedImagesAsString = ""
        var imagesToDelete = 0
        
        for cell in galleryCollectionView.visibleCells as! [GalleryCollectionViewCell] {
            if cell.isHighlighted {
                if selectedImagesAsString.count != 0  {
                    selectedImagesAsString += ","
                }
                selectedImagesAsString += (cell.image?.getImageName())!
                imagesToDelete += 1
            }
        }
        
        let alert = UIAlertController(title:"Delete?", message: "Do you really want to delete \(imagesToDelete) image(s)?", preferredStyle: .alert)
        
        let nopeAction = UIAlertAction(title: "no", style: .default, handler: { (_) in
            self.selectBarButtonPressed(self.selectBarButton)
        })
        
        let okAction = UIAlertAction(title: "yes", style: .default, handler: { (_) in
            if Communicator.deleteImage(imageNames: selectedImagesAsString){
                self.refreshGallery()
                self.selectBarButtonPressed(self.selectBarButton)
            }
        })
        
        alert.addAction(nopeAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /// Gets called when the user presses the select bar button.
    /// Switches the navigation bar on top to show the correct bar buttons.
    ///
    /// - parameter sender: the bar button that was pressed
    @IBAction func selectBarButtonPressed(_ sender: UIBarButtonItem) {
        if !highlightingMode {
            selectBarButton.title = "Done"
            self.galleryViewNavigationItem.leftBarButtonItems = [trashBarButton, downloadBarButton]
        }
        else {
            selectBarButton.title = "Select"
            self.galleryViewNavigationItem.leftBarButtonItems = [uploadBarButton]
            for cell in (galleryCollectionView.visibleCells as? [GalleryCollectionViewCell])! {
                cell.isHighlighted = false
                cell.imageSelectedView.isHidden = true
                cell.thumbnail.alpha = 1.0
            }
        }
        highlightingMode = !highlightingMode
    }
    
}
