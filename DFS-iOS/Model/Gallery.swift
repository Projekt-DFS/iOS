import Foundation

/// An object managing a collection of images.
/// It could have been named 'album', but at the time of writing, actual albums were planned to be implemented.
///
/// - author: Phillip Persch
class Gallery {
    
    // Don't confuse:
    //
    // Image = custom wrapper class for images, see Image.swift
    // UIImage = Image class of UIKit without all the additional information about the image
    // UIImageView = UI container that displays an image
    
    private var imageList = [Image]()
    
    /// Initializes a gallery by setting its images and sorting them by time (newest first).
    ///
    /// - Parameter images: the collection of images
    init(images: [Image]) {
        self.imageList = images
        sortImagesByTime()
    }
    
    init() {}
    
    /// Sorts this gallery's images by time, from newest to oldest.
    /// This guarantees that newly uploaded images are displayed first.
    public func sortImagesByTime() {
        imageList.sort { (i1, i2) -> Bool in
        Utils.secondsSince1970(image: i1) > Utils.secondsSince1970(image: i2)
        }
    }
    
    /// Getter for field imageList.
    public func getImageList() -> [Image] {
        var images = [Image]()
        for image in self.imageList{
            images.append(image)
        }
        return images
    }
    
    /// Setter for field imageList.
    public func setImageList(images: [Image]) {
        self.imageList = images
    }
}
