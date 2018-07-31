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
    
    init(){
        self.imageName = ""
        self.imageSource = ""
        self.thumbnail = ""
        self.metaData = MetaData(owner: "", created: "", location: "", tagList: [String()])
    }
    
    init(json: [String: Any]){
        imageName     =  json["imageName"   ]      as?  String          ??  ""
        imageSource   =  json["imageSource" ]      as?  String          ??  ""
        thumbnail     =  json["thumbnail"   ]      as?  String          ??  ""
        
        
        let jsonMeta      =  json["metaData"    ]      as?  [String:Any]        ??  ["":""]
        let owner = jsonMeta["owner"]!
        let created = jsonMeta["created"]!
        
        var location = String()
        if let locationTmp = jsonMeta["location"] as? String{
            location = locationTmp
        }
        
        var tagList = [String()]
        if let tagListTmp = jsonMeta["tagList"] as? [String]{
            tagList = tagListTmp
        }
        
        
        
        metaData = MetaData(owner: owner as! String, created: created as! String, location: location, tagList: tagList)
        
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
