//
//  GalleryCollectionViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 11.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit


class GalleryCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var gallery = Gallery()    // Das Gallery-Model
    var indexOfImageInDetailView: Int?
    lazy var images = gallery.getImageList()  // Array von UIImages werden als Thumbnails benutzt
    lazy var galleryCollectionViewCells = [GalleryCollectionViewCell]() // Zellen der GalleryCollectionView
    var highlightingMode = false
    
    @IBOutlet var galleryCollectionView: GalleryCollectionView!
    
    
    
    // Im Bereich bis zum nächsten Kommentar geht es um die BarButtons in der oberen Leiste. Wenn Select gedrückt wird, wechselt die Scene in den "highlightingMode", wo Bilder ausgewählt werden können. Der nächste Klick beendet das wieder.    
    
    @IBOutlet weak var selectBarButton: UIBarButtonItem!
    @IBOutlet weak var settingsBarButton: UIBarButtonItem!
    @IBOutlet var uploadBarButton: UIBarButtonItem!
    
    
    @IBOutlet var trashBarButton: UIBarButtonItem!
    @IBOutlet var downloadBarButton: UIBarButtonItem!
    
 
    @IBOutlet weak var galleryViewNavigationItem: UINavigationItem!

    @IBAction func selectBarButtonPressed(_ sender: UIBarButtonItem) {
        if !highlightingMode {
            selectBarButton.title = "Done"
            self.galleryViewNavigationItem.leftBarButtonItems = [trashBarButton, downloadBarButton]
        }
        else {
            selectBarButton.title = "Select"
            self.galleryViewNavigationItem.leftBarButtonItems = [uploadBarButton]
            for cell in galleryCollectionViewCells {
                cell.isSelected = false
                cell.imageSelectedView.isHidden = true
                cell.thumbnail.alpha = 1.0
            }
        }
        highlightingMode = !highlightingMode
    }
    
    
    
    func refreshGalleryViewFromModel() {
    }
    
    // Bereitet den ImageDetailViewController darauf vor, dass gleich ein Segue zu ihm stattfindet
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageDetailSegue" {
            let destinationVC = segue.destination as! ImageDetailViewController
            if let indexPath = self.collectionView?.indexPath(for: sender as! GalleryCollectionViewCell) {
                destinationVC.image = images[indexPath.item]
                indexOfImageInDetailView = indexPath.item
                destinationVC.galleryVC = self
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    
    // Bestimmt, was passiert wenn die view geladed wurde
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.isPrefetchingEnabled = false
        galleryCollectionView?.allowsMultipleSelection = true
        galleryViewNavigationItem.leftBarButtonItems = [uploadBarButton]
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
       cell.image = nil
        
        var image = UIImage()
        
        cell.activityIndicator.startAnimating()
        DispatchQueue.global(qos: .background).async { [weak self] in
            let urlContents = try? Data(contentsOf: (self?.images[indexPath.item].getThumbnail())!)
            if let imageData = urlContents {
                image = UIImage(data: imageData)!
                DispatchQueue.main.async {
                cell.image = image
                self?.galleryCollectionViewCells.append(cell)
                }
            }
        }
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
    
    //---BarButtonsPressed---//
    //--Upload--//
    /**
     Erzeugt ueber einen Alert den benoetigten ImagePicker und zeigt diesen anschliessend an
     */
    
    
    @IBAction func uploadBarButtonPressed(_ sender: UIBarButtonItem) {
        let imagePickerController = createPicker()
        let alert = createAlert(picker: imagePickerController)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    /**
     Erzeugt einen ImagePicker
    */
    func createPicker() -> UIImagePickerController{
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        return imagePickerController
    }
    
    /**
     Erzeugt einen UIAlertController, welcher eine Auswahl zwischen Kamera und Galerie bietet
     */
    func createAlert(picker: UIImagePickerController) -> UIAlertController{
        let alert = UIAlertController(title: "Image Source", message: "Please select", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alert
    }
    
    /**
     Wird ausgefuehrt, sobald der ImagePicker ein Bild gepickt hat (entweder ueber Kamera oder als Auswahl in der Galerie)
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let data = UIImagePNGRepresentation(image)
            if Communicator.uploadImage(data: data!){
                //aktualisiere Galerie
            }
            else{
                //Zeige Fehlermeldung
            }
        picker.dismiss(animated: true, completion: nil)
        }
    }
    
    /**
     Wenn kein Bild ausgewaehlt wurde, so wird der Picker trotzdem korrekt beendet
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    //--Download--//
    
    @IBAction func downloadBarButtonPressed(_ sender: UIBarButtonItem) {
        print("download")
    }
    
    //--Trash--//

    @IBAction func trashBarButtonPressed(_ sender: UIBarButtonItem) {
        print("trash")
    }
    
}
