import UIKit

/// Custom cell class for the gallery collection view
///
/// - author: Phillip Persch
class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!

    var image : Image?
    var uiImage: UIImage? {
        didSet {
            thumbnail.image = uiImage
            activityIndicator.stopAnimating()
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var imageSelectedView: UIImageView!
    
    func changeHighlighting(to toHighlighted: Bool) {
        if toHighlighted {
            thumbnail.alpha = 0.4
            imageSelectedView.isHidden = false
            isHighlighted = true
        } else {            
            thumbnail.alpha = 1.0
            imageSelectedView.isHidden = true
            isHighlighted = false
        }
    }

}
