//
//  Communicator.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation

class Communicator {
    
    static var userName = ""
    static var password = ""
    static var ip       = ""
    
    //GET imageList
    /**
     Schickt pw und id codidert als Base64 an das Backend. Dort wird auf Richtigkeit der Daten geprueft
     Bei Erfolg erhaelt der Nutzer Zugang zur Gallery.
     */
    static func getImageInfo() -> [Image]?{
        
        let url = URL(string: "http://\(ip):4434/iosbootstrap/v1/images/\(userName)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        

        let userNameAndPwBase64 = Utils.encodeStringToBase64(str: "\(userName):\(password)")
        request.addValue("Basic \(userNameAndPwBase64)", forHTTPHeaderField: "Authorization")
        
        print(userNameAndPwBase64)
        
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
    static func uploadImage(imageString: String, imgName: String) -> Bool{
        
        //wird noch anstaendig gemacht
        let json = "{\n\t\"imageSource\":\"\(imageString)\",\n\t\"imageName\":\"\(imgName)\"\n}"
        
        var request = initRequest(url: "http://\(ip):4434/iosbootstrap/v1/images/\(userName)", method: "POST")

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
    static func getImage(urlAsString: String) -> Data{
        
        let request = initRequest(url: urlAsString, method: "GET")
        
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
            print("Communicator: Loading image failed")
        }else{
            print("Communicator: Loading image successful")
        }
        
        return imageData
    }
    
    //PUT MetaData
    static func updateMetaData() -> Bool{
        return true
    }
    
    
    
    //DELETE Image
    static func deleteImage() -> Bool{
        
        //der link ist noch hardgecodet, sollte fuer ein Bild "Noname.jpg" im Backend funktionieren
        let request = initRequest(url: "http://\(ip):4434/iosbootstrap/v1/images/\(userName)?imageName=Noname.jpg", method: "DELETE")
        
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
        
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        
        
        let userNameAndPwBase64 = Utils.encodeStringToBase64(str: "\(userName):\(password)")
        
        request.httpMethod = method
        request.addValue("Basic \(userNameAndPwBase64)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
