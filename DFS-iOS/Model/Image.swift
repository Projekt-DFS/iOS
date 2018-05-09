//
//  Image.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation

class Image {
    var metaData : [String]?
    var source : URL            // ist noch nicht geklärt. URL wär einfach
    var thumbnail: Image?
    
    init() {
        source = URL(string: "http://nirgendwo.edu")!
        thumbnail = nil
        metaData = nil
    }
    
    
}
