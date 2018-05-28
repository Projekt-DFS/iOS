//
//  JsonParser.swift
//  DFS-iOS
//
//  Created by Conriano on 28.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation

class JsonParser{
    
    //rueckgabeWert fehlt noch
    static func parseFromJsonToMetaData(data: Data) {
    
        let jsonDataExtracted = extractJsonData(data: data)
        let metaData = MetaData.init(json: jsonDataExtracted)
        
        // return metaData sobald Bennis Klasse steht
        
    }
    
    
    static func extractJsonData(data: Data) -> [String: Any] {

        do{
            guard let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                return ["":""] //geht bestimmt klueger... mal sehen
            }
            return jsonData
        }catch let jsonErr{
            print(jsonErr)
            return ["":""]
        }
    }
    
}


//-----Structs-----//

//fuer die Methode: parseFromJsonToMetaData
struct MetaData{
    let owner    : String
    let date     : String
    let location : String
    let tags     : String
    
    init(json: [String: Any]){
        owner     =  json["owner"   ]  as? String ?? ""
        date      =  json["date"    ]  as? String ?? ""
        location  =  json["location"]  as? String ?? ""
        tags      =  json["tags"    ]  as? String ?? ""
    }
}
