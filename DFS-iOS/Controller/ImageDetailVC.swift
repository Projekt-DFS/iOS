import UIKit

/// Controller for the image detail scene.
///
/// - author: Phillip Persch
class ImageDetailVC: UIViewController, UIScrollViewDelegate {

    // Constants
    private final let MINIMUM_ZOOM_SCALE: CGFloat = 1.0
    private final let MAXIMUM_ZOOM_SCALE: CGFloat = 3.0
    private final let SWIPE_ANIMATION_DURATION = 0.3
    
    
    //Vars
    @IBOutlet var imageDetailView: ImageDetailView!
    @IBOutlet weak var imageDetailNavigationItem: UINavigationItem!
    @IBOutlet weak var trashBarButton: UIBarButtonItem!
    @IBOutlet weak var metaDataBarButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    var image : Image?
    var galleryVC : GalleryVC?
    
    /// ScrollView for zooming
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = MINIMUM_ZOOM_SCALE
            scrollView.maximumZoomScale = MAXIMUM_ZOOM_SCALE
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    
    /// Declares the UIView that needs to be zoomable. This is necessary to implement protocol UIScrollViewDelegate
    ///
    /// - returns: the UIView that needs to be scaled
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /// Double tapping causes a zoom-in or -out, depending on the current zoom scale.
    ///
    /// - parameter sender: the tap gesture recognizer that noticed a double tap
    @IBAction func doubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1.0 {
            scrollView.zoomScale = 2.2
        } else {
            scrollView.zoomScale = 1.0
        }
    }
    
    /// Changes the Image that is displayed after swiping from left to right.
    /// If the index of the current image in the gallery is not 0, it will switch to the previous image.
    ///
    /// - parameter sender: the tap gesture recognizer that noticed a swipe
    @IBAction func swipedRight(_ sender: UISwipeGestureRecognizer) {
        if let path = galleryVC?.indexOfImageInDetailView {
            if path == 0 {return}
            galleryVC?.indexOfImageInDetailView! -= 1
        }
        image = galleryVC?.images[(galleryVC?.indexOfImageInDetailView)!]
        imageDetailView.slideInImage(fromDirection: "left", duration: SWIPE_ANIMATION_DURATION)
        setupScrollView()
    }
    

    /// Changes the Image that is displayed after swiping from right to left.
    /// If the current image is not the last image in the gallery, it will switch to the next image.
    ///
    /// - parameter sender: the tap gesture recognizer that noticed a swipe
    @IBAction func swipedLeft(_ sender: Any) {
        if let path = galleryVC?.indexOfImageInDetailView {
            if path == (galleryVC?.images.count)!-1 { return }
            galleryVC?.indexOfImageInDetailView! += 1
        }
        image = galleryVC?.images[(galleryVC?.indexOfImageInDetailView!)!]
        imageDetailView.slideInImage(fromDirection: "right", duration: SWIPE_ANIMATION_DURATION)
        setupScrollView()
        
    }
 
    /// Initializes the size and appearance of the scroll view.
    /// Loads the image to be displayed from the backend.
    func setupScrollView() {
        imageDetailNavigationItem.title = image?.getImageName()
        scrollView.contentSize = imageView.frame.size
        scrollView.zoomScale = 1.0
        metaDataBarButton.isEnabled = false
        trashBarButton.isEnabled = false
        
        activityIndicator.startAnimating()
        imageView.image = nil
        
        // network call --> not on main thread
        // this is where the actual image is loaded from the backend using the path stored in the Image object
        // "weak self" in closure because the scene could be changed while this thread is running, and self could not exist anymore.
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let urlContents = Communicator.getImage(urlAsString: (self?.image?.getImageSource())!) as Data?{
                DispatchQueue.main.async {
                    if let image = UIImage(data: urlContents) {
                        self?.imageView.image = image
                        self?.activityIndicator.stopAnimating()
                        self?.metaDataBarButton.isEnabled = true
                        self?.trashBarButton.isEnabled = true
                    }
                }
            }
        }
    }
    
    /// Called after the controller's view is loaded into memory. Sets up the scroll view containing the image.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }
    
    
    ///Prepares the controller for the metaData scene or the gallery scene for the segue that will happen.
    ///
    ///Two cases:
    ///     1) Segue to metaData scene: injects the current instance of GalleryVC
    ///        into the metaData scene to allow to refresh the UI if changes are made.
    ///
    ///     2) Unwind segue to gallery: delete the image and return to the gallery scene.
    ///
    /// - parameter segue: the segue that will happen
    /// - parameter sender: the bar button who requested the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "metaDataSegue" {
            let destinationVC = segue.destination as! MetaDataVC
            destinationVC.galleryVC = self.galleryVC
            destinationVC.image = (galleryVC?.images[(galleryVC?.indexOfImageInDetailView)!])!
        } else if segue.identifier == "unwindToGallerySegue" {
            if let name = image?.getImageName() {
                if Communicator.deleteImage(imageNames: name) {
                    print("done")
                }
            }
            let destinationVC = segue.destination as! GalleryVC
            destinationVC.refreshGallery()
        }
        
    }
    
    /// Gets called when the user presses the trash bar button.
    /// Asks the user for confirmation before removing the image from the backend.
    ///
    /// - parameter sender: the bar button that was pressed
    @IBAction func trashBarButtonPressed(_ sender: UIBarButtonItem) {
        showTrashAlert()
    }
    
    
    /// Shows the alert to handle deletion of an image.
    /// If the user confirms, it will call the unwind segue to the gallery, which will then remove the image from the backend.
    func showTrashAlert() {
        let alert = UIAlertController(title:"Delete?", message: "Do you really want to delete \(image?.getImageName() ?? "")", preferredStyle: .alert)

        let nopeAction = UIAlertAction(title: "no", style: .default, handler: nil)
        
        let okAction = UIAlertAction(title: "yes", style: .default, handler: { (_) in
            self.performSegue(withIdentifier: "unwindToGallerySegue", sender: self)
        })
         
        alert.addAction(nopeAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    
}
