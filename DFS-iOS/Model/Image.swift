//
//  Image.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation
import UIKit // hat eigentlich nichts im Model verloren. Geht weg, wenn Backend steht

class Image {
    var metaData : [String]?
    var source : URL            // ist noch nicht geklärt. URL wär einfach
    var thumbnail: UIImage
    
    init() {
        source = URL(string: "http://nirgendwo.edu")!
        thumbnail = Image.selectRandomThumbnail()
        metaData = nil
    }
    
    // debug-only: Image-Objekte werden mit Bildern aus Assets zufällig bestückt.
    
    static func selectRandomThumbnail() -> UIImage {
        let imageNames = ["pic1", "pic2", "pic3", "pic4", "pic5", "pic6", "pic7", "pic8", "pic9", "pic10", "pic11", "pic12", "pic13", "pic14", "pic15", "pic16", "pic17"]
        let index = imageNames.count.arc4random
        return UIImage(named: imageNames[index])!
    }    
    
    public func getThumbnail() -> UIImage {
        return self.thumbnail
    }
    
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else {return 0}
    }
}
