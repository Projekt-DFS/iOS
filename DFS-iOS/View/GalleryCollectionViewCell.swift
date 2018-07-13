//
//  GalleryCollectionViewCell.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 11.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    var image : Image?
    var uiImage: UIImage? {
        didSet {
            thumbnail.image = uiImage
            activityIndicator.stopAnimating()
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageSelectedView: UIImageView!
}
