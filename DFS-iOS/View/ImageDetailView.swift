import UIKit

/// View class for the image detail scene
///
/// - author: Phillip Persch
class ImageDetailView: UIView {
    
    /// When swiping through images in the image detail scene, this function creates the sliding animation.
    /// depending on the direction of the swipe, the next image slides in from the left or the right.
    ///
    /// - parameter fromDirection: the direction the slide in animation should come from
    /// - parameter duration: the amount of time the slide in animation should take
    func slideInImage(fromDirection: String, duration: CFTimeInterval, completionDelegate: AnyObject? = nil) {
        let slideInTransition = CATransition()
        
        slideInTransition.type = kCATransitionPush
        if fromDirection == "right" {
            slideInTransition.subtype = kCATransitionFromRight
        } else if fromDirection == "left" {
            slideInTransition.subtype = kCATransitionFromLeft
        }
        slideInTransition.duration = duration
        slideInTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInTransition.fillMode = kCAFillModeRemoved
        
        
        self.layer.add(slideInTransition, forKey: "slideInTransition")        
        
    }
}
