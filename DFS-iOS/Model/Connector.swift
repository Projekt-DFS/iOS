//
//  Connector.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation

class Connector {
    var ip: String
    var isConnected: Bool
    
    init(){
        ip = ""
        isConnected = false
    }
    
    func generateConnection() -> Bool {
        return true
    }
    
    func stopConnection() -> Bool {
        return true
    }
    
    func setIP() {
        // Gedanke: ip kann eine computed property sein, dann hat sie direkt eine set-Methode.
        // https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Properties.html
    }
    
    func authenticate() -> Bool {
        return true
    }
}
