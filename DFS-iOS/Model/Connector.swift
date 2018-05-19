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
    }
    
    func authenticate() -> Bool {
        return true
    }
}
