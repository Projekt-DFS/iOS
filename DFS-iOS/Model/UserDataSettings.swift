//
//  UserData.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation

class UserData  {
    
    //---UserDefaults und Keys---//
    let defaults = UserDefaults.standard
    let userNameKey    = "userName"
    let pwKey          = "pw"
    let ipKey          = "ip"
    let autoUploadKey  = "autoUpload"
    
    //---Properties---//
    var userName   = ""
    var pw         = ""
    var ip         = ""
    var autoUpload = false
    
    
    init() {
        loadDefaultsIfSet()
    }
    
    
    func loadDefaultsIfSet(){
        if let userName = defaults.object(forKey: userNameKey) as? String{
            self.userName = userName
        }
        
        if let pw = defaults.object(forKey: pwKey) as? String {
            self.pw  = pw
        }
        
        if let ip = defaults.object(forKey: ipKey) as? String {
            self.ip = ip
        }
        
        if defaults.bool(forKey: autoUploadKey) {
            self.autoUpload = true
        }
    }
    
    func setDefaultUserName(_ to: String){
        defaults.set(to, forKey: userNameKey)
    }
    
    func setDefaultPw(_ to: String){
        defaults.set(to, forKey: pwKey)
    }
    
    func setDefaultIp(_ to: String){
        defaults.set(to, forKey: ipKey)
    }
    
    func setDefaultAutoUpload(_ to: Bool){
        defaults.set(to, forKey: autoUploadKey)
    }
    
    
}
