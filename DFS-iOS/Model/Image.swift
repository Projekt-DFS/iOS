//
//  Image.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation

class Image {
    private let imageName    : String
    private let imageSource  : URL
    private let thumbnail    : URL
    private var metaData     : MetaData
    
    init(imageName: String, imageSource: String, thumbnail: String, metaData: MetaData) {
        self.imageName = imageName
        self.imageSource = URL(string: imageSource)!
        self.thumbnail = URL(string: thumbnail)!
        self.metaData = metaData
    }
    
    public func getImageName() -> String{
        return self.imageName
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
