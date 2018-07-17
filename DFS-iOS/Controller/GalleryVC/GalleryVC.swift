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
    
    
    //sonstige Variablen
    var gallery = Gallery() {
        didSet{
            images = gallery.getImageList()
        }
    }
    var indexOfImageInDetailView: Int?
    var images = [Image]()
    lazy var galleryCollectionViewCells = [GalleryCollectionViewCell]()
    var highlightingMode = false

    
    
    // Bestimmt, was passiert wenn die view geladen wurde
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.isPrefetchingEnabled = true
        galleryCollectionView?.allowsMultipleSelection = true
        galleryViewNavigationItem.leftBarButtonItems = [uploadBarButton]
    }
    
    @objc func refreshGallery() {
        if let newImages = Communicator.getImageInfo() {
            self.gallery = Gallery(images: newImages)
            self.collectionView?.reloadData()
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GalleryCollectionViewCell
       cell.uiImage = nil
        
        cell.activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            if let urlContents = Communicator.getImage(urlAsString: (self?.images[indexPath.item].getThumbnail())!) as Data?{
                if let uiImage = UIImage(data: urlContents) {
                    DispatchQueue.main.async {
                        cell.image = self?.images[indexPath.item]
                        cell.uiImage = uiImage
                        self?.galleryCollectionViewCells.append(cell)
                    }
                }
            }
        }
        print(indexPath.item)
        return cell
    }
    

    // Bestimmt, was passiert wenn eine Zelle ausgewählt wird
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = galleryCollectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        if highlightingMode {
            cell.thumbnail.alpha = 0.4
            cell.isSelected = true
            cell.imageSelectedView.isHidden = false
        } else {
            self.performSegue(withIdentifier: "imageDetailSegue", sender: cell)
        }
        print(indexPath.item)
    }
    
    // Bestimmt, was passiert wenn eine Auswahl revidiert wird
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = galleryCollectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        if highlightingMode {
            cell.thumbnail.alpha = 1.0
            cell.imageSelectedView.isHidden = true
            cell.isSelected = false
        }        
    }
    
    
}
