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
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("Basic \(userNameAndPwBase64)", forHTTPHeaderField: "Authorization")
        
        var status = Int()
        
        let sem = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            guard let data = data, error == nil else{
                print("error")
                sem.signal()
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

    
    //POST Image
    static func uploadImage(data: Data) -> Bool{
        
        let imageBase64 = Utils.encodeDataToBase64(data: data)
        
        //wird noch anstaendig gemacht
        let json = "{\n\t\"image\"=\"\(imageBase64)\"\n}"
        
        let uds = UserDataSettings()
        
        let url = URL(string: "http://\(uds.getDefaultIp):8080/dfs/users/1/images")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let userNameAndPwBase64 = Utils.encodeStringToBase64(str: "\(uds.getDefaultUserName()):\(uds.getDefaultPw())")
        request.addValue("Basic \(userNameAndPwBase64)", forHTTPHeaderField: "Authorization")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = imageBase64.data(using: .utf8)
        
        var status = Int()
        
        let sem = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            guard let data = data, error == nil else{
                print("error")
                sem.signal()
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print(httpStatus.statusCode)
                print(response!)
            }
            
            if let httpStatus = response as? HTTPURLResponse{
                status = httpStatus.statusCode
            }
            
            sem.signal()
        }
        task.resume()
        
        sem.wait()
        
        if(status != 200){
            return false
        }
        
        print("Image upload successful")
        return true
    }
    
    //GET Image
    //Passiert aktuell noch in der Gallery, wird gefixt
    static func getImage() -> Bool{
        return true
    }
    
    //PUT MetaData
    static func updateMetaData() -> Bool{
        return true
    }
    
    
    
    //DELETE Image
    static func deleteImage() -> Bool{
        return true
    }
    
}
