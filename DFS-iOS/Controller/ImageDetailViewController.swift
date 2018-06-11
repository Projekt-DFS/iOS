//
//  ImageDetailViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {

    // Konstanten
    let MINIMUM_ZOOM_SCALE: CGFloat = 1.0
    let MAXIMUM_ZOOM_SCALE: CGFloat = 3.0
    let SWIPE_ANIMATION_DURATION = 0.3
    
    
    //Variablen
    @IBOutlet var imageDetailView: ImageDetailView!
    @IBOutlet weak var imageDetailNavigationItem: UINavigationItem!
    @IBOutlet weak var trashBarButton: UIBarButtonItem!
    @IBOutlet weak var metaDataBarButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    var image : Image?
    var galleryVC : GalleryCollectionViewController?
    
    
    // Scrollview um zu zoomen
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = MINIMUM_ZOOM_SCALE
            scrollView.maximumZoomScale = MAXIMUM_ZOOM_SCALE
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    //Zoomt rein bzw. raus bei Doppeltap
    @IBAction func doubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1.0 {
            scrollView.zoomScale = 2.2
        } else {
            scrollView.zoomScale = 1.0
        }
    }
    
    // Swipe zum vorherigen Bild
    @IBAction func swipedRight(_ sender: UISwipeGestureRecognizer) {
        if let _ = galleryVC?.pathOfImageInDetailView {
            galleryVC?.pathOfImageInDetailView! -= 1
        }
        image = galleryVC?.images[(galleryVC?.pathOfImageInDetailView)!]
        imageDetailView.slideInImage(fromDirection: "left", duration: SWIPE_ANIMATION_DURATION)
        viewDidLoad()
    }
    
    // Swipe zum nächsten Bild
    @IBAction func swipedLeft(_ sender: Any) {
        if let _ = galleryVC?.pathOfImageInDetailView {
            galleryVC?.pathOfImageInDetailView! += 1
        }
        image = galleryVC?.images[(galleryVC?.pathOfImageInDetailView!)!]
        imageDetailView.slideInImage(fromDirection: "right", duration: SWIPE_ANIMATION_DURATION)
        viewDidLoad()
    }
 
    // Größe und Zoom der ScrollView wird initialisiert
    func setupScrollView() {
        scrollView.contentSize = imageView.frame.size
        scrollView.zoomScale = 1.0
    }
    
    override func viewDidLoad() {
        setupScrollView()
        self.imageView.image = image?.getFullImage()
        // image wird in prepare() vom GalleryCollectionViewController gesetzt. Jetzt wird das image der imageView zugewiesen
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Bild und Metadaten aus RAM nehmen? Update 12.05.: Das macht iOS von selbst.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "metaDataSegue" {
            let destinationVC = segue.destination as! MetaDataViewController
            destinationVC.galleryVC = self.galleryVC
            destinationVC.image = galleryVC?.images[(galleryVC?.pathOfImageInDetailView)!]
        }
    }
}
