//
//  JsonParser.swift
//  DFS-iOS
//
//  Created by Conriano on 28.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation

class JsonParser{
    
    static func parseFromJsonToImageArray(data: Data) -> [Image]{
        let json = extractJsonDataFromImageContainer(data)
        
        var imageStructArray = [ImageStruct]()
        
        for container in json{
            let img = ImageStruct(json: container)
            imageStructArray.append(img)
        }
        
        var imageArray = [Image]()
        for imageStruct in imageStructArray{
        
            var ownerForMeta = "", createdForMeta = "", locationForMeta = ""
            var tagListForMeta = [""]
            
            if let owner = imageStruct.metaData["owner"] as? String {
                ownerForMeta = owner
            }
            if let created   = imageStruct.metaData["created"] as? String {
                createdForMeta = created
            }
            if let location  = imageStruct.metaData["location"] as? String{
                locationForMeta = location
            }
            if let tagList   = imageStruct.metaData["tagList"]  as? [String]{
                tagListForMeta = tagList
            }
            
            let metaData = MetaData(owner: ownerForMeta, created: createdForMeta, location: locationForMeta, tagList: tagListForMeta)
        
            imageArray.append(Image(id: imageStruct.id, imageSource: imageStruct.imageSource, thumbnail: imageStruct.thumbnail, metaData: metaData))
            
        }
        
        return imageArray
    }
    
    
    static func extractJsonDataFromImageContainer(_ data: Data) -> [[String: Any]] {
        
        do{
            guard let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
                return [["":""]]
            }
            return jsonData
        }catch let jsonErr{
            print(jsonErr)
            return [["":""]]
        }
    }
    
}


//-----Structs-----//

//mal sehen, ob wir das ueberhaupt noch brauchen
struct MetaDataStruct{
    let owner    : String
    let created  : String
    let location : String
    let tagList  : String
    
    init(json: [String: Any]){
        owner     =  json["owner"   ]  as? String ?? ""
        created   =  json["created" ]  as? String ?? ""
        location  =  json["location"]  as? String ?? ""
        tagList   =  json["tagList" ]  as? String ?? ""
    }
}

//Damit koennen wir das komplette Image-Objekt erstellen
struct ImageStruct{
    let id          : Int
    let imageSource : String
    let thumbnail   : String
    let metaData    : [String: Any]
    
    
    init(json: [String: Any]){
        id            =  json["id"   ]          as?  Int             ??  -1
        imageSource   =  json["imageSource" ]   as?  String          ??  ""
        thumbnail     =  json["thumbnail"]      as?  String          ??  ""
        metaData      =  json["metaData" ]      as?  [String: Any]   ??  ["":""]
    }
    
}








