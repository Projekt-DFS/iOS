//
//  ImageDetailViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    @IBOutlet var imageDetailView: ImageDetailView!
    @IBOutlet weak var imageDetailNavigationItem: UINavigationItem!
    @IBOutlet weak var trashBarButton: UIBarButtonItem!
    @IBOutlet weak var metaDataBarButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    var image = UIImage()
        
    // hierfür sehe ich noch keinen Nutzen. Passiert in viewDidLoad()
    func showImage() {
    }
    
    override func viewDidLoad() {
        self.imageView.image = image    // image wird in prepare() vom GalleryCollectionViewController gesetzt. Jetzt wird das image der imageView zugewiesen
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Bild und Metadaten aus RAM nehmen? Update 12.05.: Das macht iOS von selbst.
    }
}
