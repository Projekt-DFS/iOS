//
//  Utils.swift
//  DFS-iOS
//
//  Created by Conriano on 29.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation
import UIKit

class Utils{
    
    
    /**
     Erzeugt eine Toast Message, die folgendermassen aufgerufen wird:
     
     let toastLabel = Utils.showToast(message: "You downloaded 1 pic", width: Double(self.view.frame.size.width), height: Double(self.view.frame.size.height))
     self.view.addSubview(toastLabel)
     UIView.animate(withDuration: 4.0, delay: 0.2, options: .curveEaseIn, animations:{
     toastLabel.alpha = 0.0
     }, completion: {(isCompleted) in
     toastLabel.removeFromSuperview()
     })
     
     der Code hier im Kommentar dient gerade nur zur Erinnerung fuer den spaeteren Aufruf
     und kommt deshalb wieder weg
    */
    static func generateToast(message: String, width: Double, height: Double) -> UILabel{
        let toastLabel = UILabel(frame: CGRect(x: width / 2 - 125, y: height - 100, width: 250, height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 12
        toastLabel.clipsToBounds = true
        
        return toastLabel
    }
    
    
    /**
     Prueft, ob die Login-Daten eingegeben wurden
    */
    static func checkLoginDetails(name: String, pw: String, ip: String) -> Bool{
        if name == "" || pw == "" || ip == "" {
            return false
        }
        return true
    }
    
    
    
    /**
     Base64 Encoder: String -> Base64 String
    */
    static func encodeStringToBase64(str: String) -> String{
        return Data(str.utf8).base64EncodedString()
    }
    
    /**
     Base64 Encoder: Data -> Base64
    */
    static func encodeDataToBase64(data: Data) -> String{
        return data.base64EncodedString()
    }
    
    
    /**
     Generates the name of an image to get uploaded
    */
    static func generateImageName() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        var str = formatter.string(from: Date())
        str = str.replacingOccurrences(of: ".", with: "")
        str = str.replacingOccurrences(of: ", ", with: "_")
        str = str.replacingOccurrences(of: ":", with: "")
        
        return "IMG_\(str).jpg"
    }
    
    

    
}
