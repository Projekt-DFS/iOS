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
    
    // Nicht verwechseln:
    // Image = unsere eigene Hüllenklasse mit Bildern, seieh Image.swift
    // UIImage = die Imageklasse von UIKit
    // UIImageView = ein Container, der ein Bild darstellen kann
    
    private var imageList = [Image]()
    
    
    init(images: [Image]) {
        self.imageList = images
        sortImagesByTime()
    }
    
    init() {}
    
    public func sortImagesByTime() {
        imageList.sort { (i1, i2) -> Bool in
        Utils.secondsSince1970(image: i1) > Utils.secondsSince1970(image: i2)
        }
    }
    
    public func getImageList() -> [Image] {
        var images = [Image]()
        for image in self.imageList{
            images.append(image)
        }
        return images
    }
    
    public func setImageList(images: [Image]) {
        self.imageList = images
    }
}
