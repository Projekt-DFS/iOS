//
//  UserData.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation

/**
 Diese Klasse ist zustaendig fuer die Verwaltung, Speicherung und
 Einstellung von User Daten, also dem UserName, dem Passwort, der IP
 und der Auto Upload - Funktion
*/
class UserDataSettings  {
    
    //-----Properties-----//
    
    //User Daten
    var userName   = ""
    var pw         = ""
    var ip         = ""
    
    //User Defaults und Keys
    let defaults = UserDefaults.standard
    let userNameKey    = "userName"
    let pwKey          = "pw"
    let ipKey          = "ip"
    
    /**
     Die Initialisierung passiert in loadDefaultsIfSet()
    */
    init() {
        loadDefaultsIfSet()
    }
    
    
    /**
     Schaut nach, ob schon Default-Werte in der App gespeichert sind und
     uebernimmt diese. Falls noch keine gespeichert sind bleibt es bei der
     obigen Zuweisung (s. Properties)
    */
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
        
    }
    
    
    /**
     Resets the user defaults
    */
    func resetUserDefaults(){
        setDefaultIp("")
        setDefaultPw("")
        setDefaultUserName("")
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
    
    
    func getDefaultUserName() -> String{
        if let userName = defaults.object(forKey: userNameKey) as? String {
            return userName
        }else{
            return ""
        }
    }
    
    func getDefaultPw() -> String{
        if let password = defaults.object(forKey: pwKey) as? String {
            return password
        }else{
            return ""
        }
    }
    
    func getDefaultIp() -> String{
        if let ip = defaults.object(forKey: ipKey) as? String {
            return ip
        }else{
            return ""
        }
    }
    
}
