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
    
    var imageList = [Image]()
    
    
    // init == "Konstruktor"
    init() {
        let numberOfImages = 4000 // fixe Anzahl an Bildern im Moment. Wird später computed property, die das Backend vorgibt
        for _ in 0..<numberOfImages {
            imageList.append(Image())
        }
    }
    func showImage() {
        //Muesste das nicht "showThumbnails()" heißen?
    }
    
    public func getImageList() -> [UIImage] {
        var images = [UIImage]()
        for image in self.imageList{
            images.append(image.getThumbnail())
        }
        return images
    }
}
