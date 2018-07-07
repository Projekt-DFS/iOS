//
//  Communicator.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation

class Communicator {
    
    //Data for connection
    static var userName = ""
    static var password = ""
    static var ip       = ""
    
    //Link constants
    static var loginLink     : String {return "http://\(ip):4434/iosbootstrap/v1/images/\(userName)"}
    static var uploadLink    : String {return "http://\(ip):4434/iosbootstrap/v1/images/\(userName)"}
    static var deletionLink  : String {return "http://\(ip):4434/iosbootstrap/v1/images/\(userName)?imageName="}//wird ab hier um die Namen erweitert, also Name, Name, Name,...
    
    //Data grown out of a request
    static var getImageInfoData = Data()
    static var getImageData     = Data()
    
    //Marks of a request to identify it
    static let getImageInfoMark = 1
    static let getImageMark     = 2
    static let uploadImageMark  = 3
    static let deleteImageMark  = 4
    
    //Statuscodes
    static let statusCodeDictionary = [
                                       getImageInfoMark : 200,
                                       getImageMark     : 200,
                                       uploadImageMark  : 201,
                                       deleteImageMark  : 204
                                      ]
    
    //If != preferred status code, these will be set false
    static var failDictionary = [
                                    getImageInfoMark : true,
                                    getImageMark     : true,
                                    uploadImageMark  : true,
                                    deleteImageMark  : true
                                ]
    
    
    /**
     Schickt pw und id codidert als Base64 an das Backend. Dort wird auf Richtigkeit der Daten geprueft
     Bei Erfolg erhaelt der Nutzer Zugang zur Gallery und ein Daten-Array bestehend aus Bilddateien.
     */
    static func getImageInfo() -> [Image]?{
        
        let request = initRequest(url: loginLink, method: "GET")
        
        let sem = DispatchSemaphore(value: 0)
        let task = initTask(request: request, semaphore: sem, requestMark: getImageInfoMark)
        task.resume()
        
        sem.wait()
        
        if failDictionary[getImageInfoMark] == false{
            failDictionary[getImageInfoMark] = true
            return nil
        }
        print("Communicator: Login successful")
        return JsonParser.parseFromJsonToImageArray(data: getImageInfoData)
    }
    
    
    //POST Image
    static func uploadImage(jsonString: String) -> Bool{
        
        var request = initRequest(url: uploadLink, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonString.data(using: .utf8)
        
        let sem = DispatchSemaphore(value: 0)
        
        let task = initTask(request: request, semaphore: sem, requestMark: uploadImageMark)
        task.resume()
        
        sem.wait()
        
        return true
    }
    
    
   
    
    //GET Image
    /**
     Downloadet Bild-Daten anhand eines Links
    */
    static func getImage(urlAsString: String) -> Data{
        
        let request = initRequest(url: urlAsString, method: "GET")
       
        let sem = DispatchSemaphore(value: 0)
        let task = initTask(request: request, semaphore: sem, requestMark: getImageMark)
        task.resume()
        
        sem.wait()
        
        return getImageData
    }
    
    //PUT MetaData
    static func updateMetaData() -> Bool{
        return true
    }
    
    
    
    //DELETE Image
    static func deleteImage() -> Bool{
        
        //der link ist noch hardgecodet, sollte fuer ein Bild "Noname.jpg" im Backend funktionieren
        let request = initRequest(url: deletionLink, method: "DELETE")
        
        let sem = DispatchSemaphore(value: 0)
        let task = initTask(request: request, semaphore: sem, requestMark: deleteImageMark)
        task.resume()
        
        sem.wait()
        
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
    
    static func initTask(request: URLRequest, semaphore: DispatchSemaphore, requestMark: Int) -> URLSessionDataTask{
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            guard let data = data, error == nil else{
                print("error")
                failDictionary[requestMark] = false
                semaphore.signal()
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != statusCodeDictionary[requestMark] {
                print(httpStatus.statusCode)
                print(response!)
                failDictionary[requestMark] = false
                semaphore.signal()
                return
            }
            
            if(requestMark == getImageInfoMark){
                getImageInfoData = data
            }
            if(requestMark == getImageMark){
                getImageData = data
            }
            
            semaphore.signal()
        }
        return task
    }
    
}
