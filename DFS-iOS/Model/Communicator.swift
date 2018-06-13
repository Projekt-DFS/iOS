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
    static func logIn(userName: String, password: String, ip: String) -> [Image]?{
        
        var images = [Image]()
        let userNameAndPwBase64 = Utils.encodeStringToBase64(str: "\(userName):\(password)")
        
        let url = URL(string: "http://\(ip):8080/dfs/users/1/images")!
        
        print(url)
        print(userNameAndPwBase64)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Basic \(userNameAndPwBase64)", forHTTPHeaderField: "Authorization")
        
        var status = Int()
        
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
            
            images = JsonParser.parseFromJsonToImageArray(data: data)
            
            sem.signal()
        }
        task.resume()
        
        sem.wait()
        
        if(status != 200){
            return nil
        }
        print("Login successful")
        return images
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
