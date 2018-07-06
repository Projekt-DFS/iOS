//
//  Communicator.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation

class Communicator {
    
    //GET imageList
    /**
     Schickt pw und id codidert als Base64 an das Backend. Dort wird auf Richtigkeit der Daten geprueft
     Bei Erfolg erhaelt der Nutzer Zugang zur Gallery.
     */
    static func getImageInfo(userName: String, password: String, ip: String) -> [Image]?{
        
        var request = initRequest(url: "http://\(ip):4434/iosbootstrap/v1/images/\(userName)", method: "GET")
        //request.addValue(Utils.encodeStringToBase64(str: "Basic \(userName):\(password)"), forHTTPHeaderField: "Authorization")
        var status = Int()
        var imageData = Data()
        
        
        
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
            imageData = data
            sem.signal()
        }
        task.resume()
        
        sem.wait()
        
        if(status != 200){
            print(status)
            return nil
        }
        print("Communicator: Login successful")
        return JsonParser.parseFromJsonToImageArray(data: imageData)
    }
    

    
    //POST Image
    static func uploadImage(data: Data, imgName: String) -> Bool{
        
        let imageBase64 = Utils.encodeDataToBase64(data: data)
        
        //wird noch anstaendig gemacht
        let json = "{\n\t\"imageSource\":\"\(imageBase64)\",\n\t\"imageName\":\"\(imgName)\"\n}"
        
        let uds = UserDataSettings()
        
        var request = initRequest(url: "http://\(uds.getDefaultIp()):4434/iosbootstrap/v1/images/\(uds.getDefaultUserName())", method: "POST")

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = json.data(using: .utf8)
        
        var status = Int()
        
        let sem = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            guard let _ = data, error == nil else{
                print("error")
                sem.signal()
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {
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
        
        if(status != 201){
            return false
        }
        print("Communicator: Upload successful")
        return true
    }
    
    
   
    
    //GET Image
    /**
     Downloadet Bild-Daten anhand eines Links
    */
    static func getImage(url: URL) -> Data{
        let uds = UserDataSettings()
        
        var request = URLRequest(url: url)
        let userNameAndPwBase64 = Utils.encodeStringToBase64(str: "\(uds.getDefaultUserName()):\(uds.getDefaultPw())")
        request.addValue("Basic \(userNameAndPwBase64)", forHTTPHeaderField: "Authorization")
        
        var status = Int()
        var imageData = Data()
        
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
                imageData = data
            }
            sem.signal()
        }
        task.resume()
        
        sem.wait()
        
        if(status != 200){
            print("Communicator: Loading thumbnail failed")
        }
        print("Communicator: Getting thumbnail successful")
        
        return imageData
    }
    
    //PUT MetaData
    static func updateMetaData() -> Bool{
        return true
    }
    
    
    
    //DELETE Image
    static func deleteImage() -> Bool{
        
        let uds = UserDataSettings()
        
        //der link ist noch hardgecodet, sollte fuer ein Bild "Noname.jpg" im Backend funktionieren
        let request = initRequest(url: "http://\(uds.getDefaultIp()):4434/iosbootstrap/v1/images/\(uds.getDefaultUserName())?imageName=Noname.jpg", method: "DELETE")
        
        var status = Int()
        
        let sem = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            guard let _ = data, error == nil else{
                print("error")
                sem.signal()
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {
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
        
        if(status != 204){
            return false
        }
        print("Communicator: Deletion successful")
        return true
    }
    
    
    
    static func initRequest(url: String, method: String) -> URLRequest{
        let uds = UserDataSettings()
        
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        
        let userNameAndPwBase64 = Utils.encodeStringToBase64(str: "\(uds.getDefaultUserName()):\(uds.getDefaultPw())")
        request.httpMethod = method
        request.addValue("Basic \(userNameAndPwBase64)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
