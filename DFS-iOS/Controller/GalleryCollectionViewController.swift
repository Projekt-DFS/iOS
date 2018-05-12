//
//  GalleryCollectionViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 11.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit


class GalleryCollectionViewController: UICollectionViewController {
    
    
    lazy var gallery = Gallery()
    lazy var thumbnails = gallery.getThumbnailList()
    lazy var galleryCollectionViewCells = [GalleryCollectionViewCell]()
    
    //@IBOutlet var thumbnailButtons: [UIButton]!
    
    @IBOutlet var galleryCollectionView: GalleryCollectionView!
    
    
    
    // Im Bereich bis zum nächsten Kommentar geht es um die BarButtons in der oberen Leiste. Wenn Select gedrückt wird, wechselt die Scene in den "select-Modus", wo Bilder ausgewählt werden können. Der nächste Klick beendet das wieder.
    @IBOutlet weak var uploadBarButton: UIBarButtonItem!
    
    @IBOutlet weak var selectBarButton: UIBarButtonItem!
    
    @IBOutlet weak var settingsBarButton: UIBarButtonItem!
    
    var trashBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
    var downloadBarButtonItem = UIBarButtonItem(title: "Download", style: UIBarButtonItemStyle.plain, target: self, action: nil)
    
    
    @IBOutlet weak var galleryViewNavigationItem: UINavigationItem!

    @IBAction func selectBarButtonPressed(_ sender: UIBarButtonItem) {
        if !galleryCollectionView.highlightingMode {
            selectBarButton.title = "Done"
            self.galleryViewNavigationItem.leftBarButtonItems = [trashBarButtonItem, downloadBarButtonItem]
            galleryCollectionView.highlightingMode = true
        }
        else {
            for cell in galleryCollectionViewCells {
                cell.isSelected = false
                cell.imageSelectedView.isHidden = true
                cell.thumbnail.alpha = 1.0
            }
            selectBarButton.title = "Select"
            self.galleryViewNavigationItem.leftBarButtonItems = [uploadBarButton]
            galleryCollectionView.highlightingMode = false
        }
    }
    
    
    
    
    func showGallery() {}
    
    func refreshGalleryViewFromModel() {
        //Gibts was neues vom Model? Wenn ja, update die View
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView?.allowsMultipleSelection = true
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnails.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GalleryCollectionViewCell
        
        cell.thumbnail.image = thumbnails[indexPath.item]
        galleryCollectionViewCells.append(cell)
        return cell
    }


    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = galleryCollectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        if galleryCollectionView.highlightingMode {
            cell.thumbnail.alpha = 0.4
            cell.isSelected = true
            cell.imageSelectedView.isHidden = false
        } else {
            self.performSegue(withIdentifier: "imageDetailSegue", sender: cell)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageDetailSegue" {
            let destinationVC = segue.destination as! ImageDetailViewController
            if let indexPath = self.collectionView?.indexPath(for: sender as! GalleryCollectionViewCell) {
                destinationVC.image = thumbnails[indexPath.item]
            }
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = galleryCollectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        if galleryCollectionView.highlightingMode {
            cell.thumbnail.alpha = 1.0
            cell.imageSelectedView.isHidden = true
            cell.isSelected = false
        }        
    }
    

}
