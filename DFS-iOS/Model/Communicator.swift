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
    
    //Links
    static var loginLink       : String {return "http://\(ip):4434/bootstrap/v1/images/\(userName)"}
    static var uploadLink      : String {return "http://\(ip):4434/bootstrap/v1/images/\(userName)"}
    static var deletionLink    : String {return "http://\(ip):4434/bootstrap/v1/images/\(userName)?imageName="}
    static var setMetaDataLink : String {return "http://\(ip):4434/bootstrap/v1/images/\(userName)/\(imageName)/metadata"}
    static var imageName = ""
    
    
    //Data grown out of a request
    static var getImageInfoData = Data()
    static var getImageData     = Data()
    
    //Marks of a request to identify it
    static let getImageInfoMark = 1
    static let getImageMark     = 2
    static let uploadImageMark  = 3
    static let deleteImageMark  = 4
    static let putMetaDataMark  = 5
    
    //Statuscodes
    static let statusCodeDictionary = [
                                       getImageInfoMark : 200,
                                       getImageMark     : 200,
                                       uploadImageMark  : 201,
                                       deleteImageMark  : 204,
                                       putMetaDataMark  : 200
                                      ]
    
    //If != preferred status code, these will be set false
    static var failDictionary = [
                                    getImageInfoMark : true,
                                    getImageMark     : true,
                                    uploadImageMark  : true,
                                    deleteImageMark  : true,
                                    putMetaDataMark  : true
                                ]
    
    
    /**
     Schickt pw und id codidert als Base64 an das Backend. Dort wird auf Richtigkeit der Daten geprueft
     Bei Erfolg erhaelt der Nutzer Zugang zur Gallery und ein Daten-Array bestehend aus Bilddateien.
     */
    static func getImageInfo() -> Data?{
        
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

        return getImageInfoData
    }
    
    
    //POST Image
    static func uploadImage(jsonString: String, sender: GalleryVC) -> Bool{
        
        var request = initRequest(url: uploadLink, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonString.data(using: .utf8)
        
        let sem = DispatchSemaphore(value: 0)
        
        let task = initTask(request: request, semaphore: sem, requestMark: uploadImageMark)
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            task.resume()
            sem.wait()
            DispatchQueue.main.async {
                sender.refreshGallery()
            }
        }
        
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
    static func updateMetaData(imageName: String, jsonString: String) -> Bool{
        self.imageName = imageName
        print(imageName)
        print(jsonString)
        print(setMetaDataLink)
        var request = initRequest(url: setMetaDataLink, method: "PUT")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonString.data(using: .utf8)
        
        let sem = DispatchSemaphore(value: 0)
        let task = initTask(request: request, semaphore: sem, requestMark: putMetaDataMark)
        task.resume()
        sem.wait()
        
        return true
    }
    
    
    
    //DELETE Image
    static func deleteImage(imageNames: String) -> Bool{
        
        let deletionLink = "\(self.deletionLink)\(imageNames)"
        
        //der link ist noch hardgecodet, sollte fuer ein Bild "Noname.jpg" im Backend funktionieren
        let request = initRequest(url: deletionLink, method: "DELETE")
        
        let sem = DispatchSemaphore(value: 0)
        let task = initTask(request: request, semaphore: sem, requestMark: deleteImageMark)
        task.resume()
        
        sem.wait()
        
        return true
    }
    
    /**
     Initializes a URLRequest
    */
    static func initRequest(url: String, method: String) -> URLRequest{
        
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        
        let userNameAndPwBase64 = Utils.encodeStringToBase64(str: "\(userName):\(password)")
        
        request.httpMethod = method
        request.addValue("Basic \(userNameAndPwBase64)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    /**
     Initializes a URLSessionDataTask
     */
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
