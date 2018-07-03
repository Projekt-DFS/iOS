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
    private let id           : Int
    private let imageSource  : URL
    private let thumbnail    : URL
    private var metaData     : MetaData
    
    init(id: Int, imageSource: String, thumbnail: String, metaData: MetaData) {
        self.id = id
        self.imageSource = URL(string: imageSource)!
        self.thumbnail = URL(string: thumbnail)!
        self.metaData = metaData
    }
    
    public func getId() -> Int{
        return self.id
    }
    
    public func getThumbnail() -> URL {
        return self.thumbnail
    }
    
    public func getImageSource() -> URL {
        return self.imageSource
    }
    
    public func getMetaData() -> MetaData {
        return self.metaData
    }
    
    public func setMetaData(metaData: MetaData) {
        self.metaData = metaData
    }
    

}
