//
//  GalleryCollectionViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 11.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit


class GalleryCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Outlets
    @IBOutlet var galleryCollectionView: GalleryCollectionView!
    @IBOutlet weak var galleryViewNavigationItem: UINavigationItem!
    @IBOutlet weak var selectBarButton: UIBarButtonItem!
    @IBOutlet weak var settingsBarButton: UIBarButtonItem!
    @IBOutlet var uploadBarButton: UIBarButtonItem!
    @IBOutlet var trashBarButton: UIBarButtonItem!
    @IBOutlet var downloadBarButton: UIBarButtonItem!
    
    
    //sonstige Variablen
    lazy var gallery = Gallery()    // Das Gallery-Model
    var indexOfImageInDetailView: Int?
    lazy var images = gallery.getImageList()  // Array von UIImages werden als Thumbnails benutzt
    lazy var galleryCollectionViewCells = [GalleryCollectionViewCell]() // Zellen der GalleryCollectionView
    var highlightingMode = false
    var loginVC = LoginViewController()
    var refreshControl = UIRefreshControl()

    
    
    // Bestimmt, was passiert wenn die view geladen wurde
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        galleryCollectionView.isPrefetchingEnabled = false
        galleryCollectionView?.allowsMultipleSelection = true
        galleryViewNavigationItem.leftBarButtonItems = [uploadBarButton]
    }
    
    @objc func refreshGallery() {
        if let newImages = Communicator.getImageInfo(userName: loginVC.uds.getDefaultUserName(), password: loginVC.uds.getDefaultPw(), ip: loginVC.uds.getDefaultIp()) {
            self.gallery.setImageList(images: newImages)
        }
        refreshControl.endRefreshing()
        viewDidLoad()
        
    }
    
    func setupRefreshControl() {
        if galleryCollectionView.refreshControl == nil {
            refreshControl.addTarget(self, action: #selector(refreshGallery), for: .valueChanged)
            refreshControl.tintColor = self.view.tintColor ?? UIColor.blue
            let color = [NSAttributedStringKey.foregroundColor : self.view.tintColor ?? UIColor.blue ];
            refreshControl.attributedTitle = NSAttributedString(string: "Reloading gallery from backend...", attributes: color)
            galleryCollectionView.refreshControl = refreshControl
            refreshControl.layer.zPosition = -100
        }
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
        
        cell.activityIndicator.startAnimating()
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            if let urlContents = Communicator.getImage(url: (self?.images[indexPath.item].getThumbnail())!) as Data?{
                if let image = UIImage(data: urlContents) {
                    DispatchQueue.main.async {
                        cell.image = image
                        self?.galleryCollectionViewCells.append(cell)
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
        if var image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            image = image.updateImageOrientionUpSide()!
            let data = UIImagePNGRepresentation(image)
            let imageBase64 = Utils.encodeDataToBase64(data: data!)
            if Communicator.uploadImage(imageString: imageBase64, imgName: Utils.generateImageName()){
                //aktualisiere Galerie
            }
            else{
                //Zeige Fehlermeldung in der App
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
        var imagesSaved = 0
        for cell in galleryCollectionViewCells {
            if cell.isSelected {
                if let image = cell.image {
                    
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    imagesSaved += 1
                }
            }
        }
        let alert = UIAlertController(title:"saved", message: "\(imagesSaved) image(s) saved.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "done", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        selectBarButtonPressed(selectBarButton)
    }
    
    //--Trash--//

    @IBAction func trashBarButtonPressed(_ sender: UIBarButtonItem) {
        print("trash")
        Communicator.deleteImage()
    }
    
    //--Select--//
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
    
}
