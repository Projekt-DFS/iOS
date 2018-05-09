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
    @IBOutlet weak var imageDetailLabel: UILabel!
    // @IBOutlet var imageView : UIImageView!
    
    
    
    func showImage() {
        //kann in viewDidLoad() passieren
    }   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Bild und Metadaten aus RAM nehmen?
    }
   

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
