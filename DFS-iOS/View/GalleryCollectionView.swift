import UIKit

/// View class for the gallery view scene
///
/// - author: Phillip Persch
class GalleryCollectionView: UICollectionView {
    
    /// Gets called when the device rotates from landscape to portrait mode or vice versa.
    /// This animation does not cause the correct reloading of the collection view (different amount of rows and columns).
    func rotateAnimation() {
        let rotation = CATransition()
        
        rotation.type = kCATransitionMoveIn
        
        rotation.subtype = kCATransitionMoveIn
        
        rotation.duration = 0.3
        rotation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        rotation.fillMode = kCAFillModeRemoved
        
        self.layer.add(rotation, forKey: "rotation") 
    }
}
