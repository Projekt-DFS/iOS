//
//  Gallery.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation
import UIKit // hat eigentlich nichts im Model verloren. Geht weg, wenn Backend steht

class Gallery {
    
    var thumbnailList = [Image]()
    
    init() {
        let numberOfImages = 40
        for _ in 0..<numberOfImages {
            thumbnailList.append(Image())
        }
    }
    func showImage() {
        //Muesste das nicht "showThumbnails()" heißen?
    }
    
    public func getThumbnailList() -> [UIImage] {
        var thumbnails = [UIImage]()
        for image in self.thumbnailList{
            thumbnails.append(image.getThumbnail())
        }
        return thumbnails
    }
}
