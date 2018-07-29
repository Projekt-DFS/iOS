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
        
        var imageArray = [Image]()
        
        for container in json{
            let img = Image(json: container)
            imageArray.append(img)
            print(imageArray[0].getImageSource())
        }
        
        return imageArray
    }
    
    
    static func extractJsonDataFromImageContainer(_ data: Data) -> [[String: Any]] {
        
        do{
            guard let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
                return [["":""]]
            }
            print (jsonData)
            return jsonData
        }catch let jsonErr{
            print(jsonErr)
            return [["":""]]
        }
    }
    
}

