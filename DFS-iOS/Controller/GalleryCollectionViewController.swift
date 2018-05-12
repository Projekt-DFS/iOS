//
//  GalleryCollectionViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 11.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit


class GalleryCollectionViewController: UICollectionViewController {
    
    lazy var gallery = Gallery()    // Das Gallery-Model
    lazy var thumbnails = gallery.getThumbnailList()    // Array von UIImages werden als Thumbnails benutzt
    lazy var galleryCollectionViewCells = [GalleryCollectionViewCell]() // Zellen der GalleryCollectionView
    @IBOutlet var galleryCollectionView: GalleryCollectionView!
        
    
    // Im Bereich bis zum nächsten Kommentar geht es um die BarButtons in der oberen Leiste. Wenn Select gedrückt wird, wechselt die Scene in den "highlightingMode", wo Bilder ausgewählt werden können. Der nächste Klick beendet das wieder.
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
    
    
    
    // hierfür gibt es keinen Nutzen. Sollte aus dem Diagramm entfernt werden.
    func showGallery() {}
    
    // hierfür gibt es keinen Nutzen. Sollte aus dem Diagramm entfernt werden.

    func refreshGalleryViewFromModel() {
    }
    
    // Bereitet den ImageDetailViewController darauf vor, dass gleich ein Segue zu ihm stattfindet
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageDetailSegue" {
            let destinationVC = segue.destination as! ImageDetailViewController
            if let indexPath = self.collectionView?.indexPath(for: sender as! GalleryCollectionViewCell) {
                destinationVC.image = thumbnails[indexPath.item]
            }
        }
    }
    
    
    // Bestimmt, was passiert wenn die view geladed wurde
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView?.allowsMultipleSelection = true
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // Anzahl der Zellen == Anzahl der Bilder im Gallery-Model
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnails.count
    }
    
    // Initialisierung von Zellen in der galleryCollectionView
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GalleryCollectionViewCell
        
        cell.thumbnail.image = thumbnails[indexPath.item]
        galleryCollectionViewCells.append(cell)
        return cell
    }


    // Bestimmt, was passiert wenn eine Zelle ausgewählt wird
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
    
    // Bestimmt, was passiert wenn eine Auswahl revidiert wird
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = galleryCollectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        if galleryCollectionView.highlightingMode {
            cell.thumbnail.alpha = 1.0
            cell.imageSelectedView.isHidden = true
            cell.isSelected = false
        }        
    }
    

}
