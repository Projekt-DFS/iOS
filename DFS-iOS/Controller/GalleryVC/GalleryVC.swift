import UIKit

/// Controller for the gallery scene.
///
/// - author: Phillip Persch
class GalleryVC: UICollectionViewController, UINavigationControllerDelegate {
    
    
    //Outlets
    @IBOutlet var galleryCollectionView: GalleryCollectionView!
    @IBOutlet weak var galleryViewNavigationItem: UINavigationItem!
    @IBOutlet weak var selectBarButton: UIBarButtonItem!
    @IBOutlet weak var settingsBarButton: UIBarButtonItem!
    @IBOutlet var uploadBarButton: UIBarButtonItem!
    @IBOutlet var trashBarButton: UIBarButtonItem!
    @IBOutlet var downloadBarButton: UIBarButtonItem!
    
    
    var refreshControl = UIRefreshControl()
    var progressView = UIProgressView()
    var progressLabel = UILabel()
    var indexOfImageInDetailView: Int?
    var images = [Image]()
    var highlightingMode = false

    var gallery = Gallery() {
        didSet{
            images = gallery.getImageList()
            gallery.sortImagesByTime()
        }
    }

    
    
    /// Called after the controller's view is loaded into memory.
    /// It sets up all UI elements and loads the gallery's image into the view
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.isPrefetchingEnabled = true
        galleryCollectionView?.allowsMultipleSelection = true
        galleryViewNavigationItem.leftBarButtonItems = [uploadBarButton]
        setupRefreshControl()
        refreshGallery()
    }
    
    /// Reloads the database contents from the backend.
    /// Gives visual feedback when reloading is done.
    @objc func refreshGallery() {
        refreshControl.beginRefreshing()
        refreshControl.isHidden = false
        collectionView?.alpha = 0.6
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageData = Communicator.getImageInfo() {
                self.gallery = Gallery(images: JsonParser.parseFromJsonToImageArray(data: imageData))
                self.images = self.gallery.getImageList()
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    if self.refreshControl.isRefreshing {
                        self.collectionView?.alpha = 1.0
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        }
    }
    

    
    ///Prepares the controller for the image detail scene for the segue towards his scene that will happen.
    // Sets the destination view controller's image.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageDetailSegue" {
            let destinationVC = segue.destination as! ImageDetailVC
            if let indexPath = self.collectionView?.indexPath(for: sender as! GalleryCollectionViewCell) {
                destinationVC.image = images[indexPath.item]
                indexOfImageInDetailView = indexPath.item
                destinationVC.galleryVC = self
            }
        }
    }


    /// There is always one section. If there were an implementation for multiple albums, this would not always be 1.
    ///
    /// - returns: 1
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    /// Sets the number of items per section. Since there is only one section, it contains all images.
    ///
    /// returns: the number of images per section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    /// Initializes a cell in the collection view, including its image and all of its UI features
    /// (highlighting, activity indicator etc.). It also triggers the network call to load the actual thumbnail using
    /// the path stored in the Image object.
    ///
    /// - returns: the initialized cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GalleryCollectionViewCell
        cell.uiImage = nil
        cell.changeHighlighting(to: false)
       
        cell.activityIndicator.startAnimating()
        
        // load actual thumbnail from path of thumbnail
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in            
            if let urlContents = Communicator.getImage(urlAsString: (self?.images[indexPath.item].getThumbnail())!) as Data?{
                if let uiImage = UIImage(data: urlContents) {
                    DispatchQueue.main.async {
                        cell.image = self?.images[indexPath.item]
                        cell.uiImage = uiImage                        
                    }
                }
            }
        }
        return cell
    }
    

    /// Determines what happens when a cell gets selected.
    /// If the scene is in highlighting mode, the selected image gets displayed as highlighted (alpha is changed, icon is shown).
    /// If the scene is not in highlighting mode, it switches scenes to the image detail scene, displaying the selected image.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = galleryCollectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        if highlightingMode {
            cell.changeHighlighting(to: true)
        } else {
            self.performSegue(withIdentifier: "imageDetailSegue", sender: cell)
        }
        print(indexPath.item)
    }
    
    /// Determines what happens when a cell gets deselected.
    /// The highlighting visuals get reverted.
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = galleryCollectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        cell.changeHighlighting(to: false)
    }
    
    /// Empty implementation of an unwind segue. This is necessary when an image gets deleted in image detail scene.
    ///
    /// - parameter segue: the segue that handles the navigation after deleting an image
    @IBAction func unwindToGallery(segue: UIStoryboardSegue){}

    /// Determines what happens when the device rotates enough to change orientation (portrait vs. landscape mode)
    /// Calls the view's animation to handle rotation and reorganize the UI.
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView?.frame = self.view.frame
        galleryCollectionView.rotateAnimation()
    }
    
    /// Sets up the refresh control of cells that indicates that the image is loading.
    /// This should have been put in the View package.
    func setupRefreshControl() {
        if galleryCollectionView.refreshControl == nil {
            refreshControl.addTarget(self, action: #selector(refreshGallery), for: .valueChanged)
            refreshControl.tintColor = self.view.tintColor ?? UIColor.blue
            let color = [NSAttributedStringKey.foregroundColor : self.view.tintColor ?? UIColor.blue ];
            refreshControl.attributedTitle = NSAttributedString(string: "loading gallery from backend...", attributes: color)
            galleryCollectionView.refreshControl = refreshControl
            refreshControl.layer.zPosition = -100
        }
    }

}
