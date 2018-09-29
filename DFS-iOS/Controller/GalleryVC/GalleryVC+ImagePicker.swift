import Foundation
import UIKit
import ImagePicker
import Photos

/// Extension to GalleryVC to manage the image picker used to upload images.
///
/// - author: Phillip Persch, Julian Einspenner
extension GalleryVC: ImagePickerDelegate {
    
    
    /// Empty implementation of wrapperDidPress. This is necessary in order to implement protocol ImagePickerDelegate.
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {        
    }
    
    /// Gets called when the user presses the done button.
    /// Uploads all selected images to the backend using the Communicator functions.
    ///
    /// - parameter imagePicker: the imagePicker used
    /// - parameter images: a collection of the selected UIImages
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        progressView.isHidden = false
        progressLabel.isHidden = false
        
        // disable all buttons until the uploading process is done
        imagePicker.bottomContainer.isUserInteractionEnabled = false

        self.progressLabel.text = "uploading image \(1) of \(images.count)..."

        DispatchQueue.global(qos: .userInitiated).async {
            for img in images {
                let data = UIImagePNGRepresentation(img.updateImageOrientionUpSide()!)
                let imageBase64 = Utils.encodeDataToBase64(data: data!)
                
                let json = "{\n\t\"imageSource\":\"\(imageBase64)\",\n\t\"imageName\":\"\(Utils.generateImageName())\"\n}"
                let _ = Communicator.uploadImage(jsonString: json, sender: self)
                DispatchQueue.main.async {
                    self.progressView.progress = self.progressView.progress + Float(1.0 / Double(images.count))
                    self.progressLabel.text = "uploading image \(2 + images.index(of: img)!) of \(images.count)..."
                }
                
            }
            DispatchQueue.main.async {
                imagePicker.dismiss(animated: true, completion: nil)
                 self.refreshGallery()
            }
           
        }
    }
    
    /// Gets called when the user presses the cancel button. Dismisses the scene and switches back to the gallery scene.
    ///
    /// - parameter imagePicker: the imagePicker used
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    /// Gets called from the upload bar button handler function.
    /// Creates and presents an instance of ImagePickerController, which displays all images on the device and allows
    /// to select multiple images at once.
    ///
    /// The official apple alternative UIImagePickerController only allows the selection of one image at a time.
    /// That is not enough for an image gallery app.
    func createImagePicker() {
        var configuration = Configuration()
        configuration.cancelButtonTitle = "Cancel"
        let imagePickerController = ImagePickerController(configuration: configuration)
        imagePickerController.delegate = self
        
        initializeProgressView()
        imagePickerController.view.addSubview(progressView)
        imagePickerController.view.addSubview(progressLabel)

        
        present(imagePickerController, animated: true, completion: nil)

    }
    
    /// Initializes the ImagePicker's progress view.
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
        
        progressLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        progressLabel.center = CGPoint(x: progressView.center.x, y: progressView.center.y + 30)
        progressLabel.textColor = UIColor.white
        progressLabel.layer.zPosition = 100
        progressLabel.isHidden = true
        progressLabel.textAlignment = .center
    }
    

}
