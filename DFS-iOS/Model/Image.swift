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
    private let imageSource  : String
    private let thumbnail    : String
    private var metaData     : MetaData
    
    init(imageName: String, imageSource: String, thumbnail: String, metaData: MetaData) {
        self.imageName = imageName
        self.imageSource = imageSource
        self.thumbnail = thumbnail
        self.metaData = metaData
    }
    
    init() {
        self.imageName = ""
        self.imageSource = ""
        self.thumbnail = ""
        self.metaData = MetaData()
    }
    
    init(json: [String: Any]){
        imageName     =  json["imageName"   ]      as?  String          ??  ""
        imageSource   =  json["imageSource" ]      as?  String          ??  ""
        thumbnail     =  json["thumbnail"   ]      as?  String          ??  ""
        metaData      =  json["metaData"    ]      as?  MetaData        ??  MetaData(owner: "", created: "", location: "", tagList:[""])
    }
    
    public func getImageName() -> String{
        return self.imageName
    }
    
    public func getThumbnail() -> String {
        return self.thumbnail
    }
    
    public func getImageSource() -> String {
        return self.imageSource
    }
    
    public func getMetaData() -> MetaData {
        return self.metaData
    }
    
    public func setMetaData(metaData: MetaData) {
        self.metaData = metaData
    }
    

}
