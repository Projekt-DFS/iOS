//
//  MetaData.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 11.06.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation
class MetaData {
    private var owner: String
    private var created: String
    private var location: String
    private var tagList : [String]
    
    init(owner: String, created:String, location: String, tagList:[String]) {
        self.owner = owner
        self.created = created
        self.location = location
        self.tagList = tagList
    }
    
    init(){
        self.owner    =  ""
        self.created  =  ""
        self.location =  ""
        self.tagList  = [String]()
    }
      
    func getOwner() -> String {
        return self.owner
    }
    
    func setOwner(newValue: String) {
        self.owner = newValue
    }
    
    func getLocation() -> String {
        return self.location
    }
    
    func setLocation(newValue: String) {
        self.location = newValue
    }
    
    func getCreated() -> String {
        return self.created
    }
    
    func setCreated(newValue: String) {
        self.created = newValue
    }
    
    func getTagList() -> [String]{
            return tagList
    }
    
    func getTagListAt(index: Int) -> String {
        if self.tagList.count <= index {
            return ""
        }
        
        return self.tagList[index]
    }
    
    func appendToTagList(index: Int, newValue: String) {
        if tagList.count < 3 {
        self.tagList.append(newValue)
        } else {
            tagList[index] = newValue
        }
        
    }
}
