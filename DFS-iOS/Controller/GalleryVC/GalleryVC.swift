//
//  GalleryCollectionViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 11.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit


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


    
    //sonstige Variablen
    var gallery = Gallery() {
        didSet{
            images = gallery.getImageList()
            gallery.sortImagesByTime()
        }
    }
    var indexOfImageInDetailView: Int?
    var images = [Image]()
    var highlightingMode = false

    
    
    // Bestimmt, was passiert wenn die view geladen wurde
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.isPrefetchingEnabled = true
        galleryCollectionView?.allowsMultipleSelection = true
        galleryViewNavigationItem.leftBarButtonItems = [uploadBarButton]
        setupRefreshControl()
        print("viewDidLoad called")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called")

        refreshGallery()
    }
    
    
    
        
    @objc func refreshGallery() {
        refreshControl.beginRefreshing()
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
    

    
    // Bereitet den ImageDetailViewController darauf vor, dass gleich ein Segue zu ihm stattfindet
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


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // Anzahl der Zellen == Anzahl der Bilder im Gallery-Model
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // Initialisierung von Zellen in der galleryCollectionView
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GalleryCollectionViewCell
        cell.uiImage = nil
        cell.changeHighlighting(to: false)
       
        cell.activityIndicator.startAnimating()
        
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
    

    // Bestimmt, was passiert wenn eine Zelle ausgewählt wird
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = galleryCollectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        if highlightingMode {
            cell.changeHighlighting(to: true)
        } else {
            self.performSegue(withIdentifier: "imageDetailSegue", sender: cell)
        }
        print(indexPath.item)
    }
    
    // Bestimmt, was passiert wenn eine Auswahl revidiert wird
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = galleryCollectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        cell.changeHighlighting(to: false)
    }
    @IBAction func unwindToGallery(segue: UIStoryboardSegue){}

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView?.frame = self.view.frame
        galleryCollectionView.rotateAnimation()
    }
    
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
