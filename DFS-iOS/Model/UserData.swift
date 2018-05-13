//
//  UserData.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation

class UserData  {
    
    var pw : String  // Verschluesselung?!?!
    var userName : String {
        get {
           return self.userName
        }
        set{
            self.userName = newValue
        }
        // Ich glaube so macht man eigentlich getter und setter (computed properties)
    }
    
    func checkInput() {} // kommt raus
    
    init() {
        pw = ""
        userName = ""
    }
   
    
}
