//
//  Communicator.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import Foundation

class Communicator {
    
    
    init(){
        
    }
    
    //POST Login
    /**
     Schickt pw und id codidert als Base64 an das Backend. Dort wird auf Richtigkeit der Daten geprueft
     Bei Erfolg erhaelt der Nutzer Zugang zur Gallery.
    */
    func logIn(){
        let userData = UserDataSettings()
        
        let userNameBase64 = Utils.encodeStringToBase64(str: userData.userName)
        let pwBase64 = Utils.encodeStringToBase64(str: userData.pw)
        
        let url = URL(string: userData.ip)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //will Aude so haben. Hinter dem Code steckt "user:admin"
        request.addValue("dXNlcjphZG1pbg=", forHTTPHeaderField: "Authorization")
        
        let loginJSON = "{\n\tusername: \(userNameBase64)\n\tpassword: \(pwBase64)\n}"
        request.httpBody = loginJSON.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            guard let data = data, error == nil else{
                print("error")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print(httpStatus.statusCode)
                print(response!)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print(responseString!)
        }
        task.resume()
    }
    
    //POST Logout
    func logOut() -> Bool{
        return true
    }
    
    //GET ThumbnailLinks
    func getThumbnails(){
        
    }
    
    //GET Thumbnails, als Image in Data-Form anhand der vorher erhaltenen Links
    /**
     Download der Thumbnails anhand deren Link. Zurueckgegeben wird ein Data-Array
    */
    func getThumbnails(links: [String]) -> [Data]{
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
    func getImage() -> Bool{
        return true
    }
    
    //PUT MetaData
    func updateMetaData() -> Bool{
        return true
    }
    
    //POST Image
    func uploadImage() -> Bool{
        return true
    }
    
    //DELETE Image
    func deleteImage() -> Bool{
        return true
    }
    
}
