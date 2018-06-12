//
//  Communicator.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation

class Communicator {
    
    //GET Login
    /**
     Schickt pw und id codidert als Base64 an das Backend. Dort wird auf Richtigkeit der Daten geprueft
     Bei Erfolg erhaelt der Nutzer Zugang zur Gallery.
     */
    static func logIn() -> Bool{
        
        let userData = UserDataSettings()
        
        let userNameBase64 = Utils.encodeStringToBase64(str: userData.userName)
        let pwBase64 = Utils.encodeStringToBase64(str: userData.pw)
        
        //später statt der 1 den richtigen name des users
        let url = URL(string: "http://192.168.0.161:8080/iosbootstrap/v1/users/1/images")!
        
        var request = URLRequest(url: url)
        
        //wurde jetzt wohl doch zur GET-Request...
        request.httpMethod = "GET"
        
        //hier drin stecken die Anmeldedaten fuer user:user
        request.addValue("Basic dXNlcjp1c2Vy", forHTTPHeaderField: "Authorization")
        
        var status = Int()
        var responseString = String()
        
        let sem = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            guard let data = data, error == nil else{
                print("error")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print(httpStatus.statusCode)
                print(response!)
            }
            
            if let httpStatus = response as? HTTPURLResponse{
                status = httpStatus.statusCode
            }
            
            responseString = String(data: data, encoding: .utf8)!
            
            sem.signal()
        }
        task.resume()
        
        sem.wait()
        
        if(status != 200){
            return false
        }
        
        print("Login successfull")
        return true
    }
    
    //POST Logout
    static func logOut() -> Bool{
        return true
    }
    
    
    //GET Thumbnails, als Image in Data-Form anhand der vorher erhaltenen Links
    /**
     Download der Thumbnails anhand deren Link. Zurueckgegeben wird ein Data-Array
     */
    static func getThumbnails(links: [String]) -> [Data]{
        var data = [Data]()
        
        links.forEach{link in
            
            let url = URL(string: link)
            
            if let thumbnailData = try? Data(contentsOf: url!){
                data.append(thumbnailData)
            }else{
                print("Failed at link number \(data.count)")
            }
        }
        
        return data
    }
    
    //GET Image
    static func getImage() -> Bool{
        return true
    }
    
    //PUT MetaData
    static func updateMetaData() -> Bool{
        return true
    }
    
    //POST Image
    static func uploadImage() -> Bool{
        return true
    }
    
    //DELETE Image
    static func deleteImage() -> Bool{
        return true
    }
    
}
