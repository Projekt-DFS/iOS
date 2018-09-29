import Foundation

/// This class arranges the communication with the CAN-Backends REST-Api.
/// It stores information about user details and request-links.
/// The methods initRequest and initTask support a non-redundant code design
/// For further information please read their documentation
/// Aside from that, the class knows expected status codes for each request. It proves, if
/// the expected codes are given in the response of the REST-call
/// - author: Julian Einspenner
class Communicator {
    
    //Login details
    static var userName = ""
    static var password = ""
    static var ip       = ""
    
    //Links for REST-calls
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
                                       uploadImageMark  : 200,
                                       deleteImageMark  : 204,
                                       putMetaDataMark  : 200
                                      ]
    
    //If response has not got  the preferred status code, the associated mark will be false
    static var failDictionary = [
                                    getImageInfoMark : true,
                                    getImageMark     : true,
                                    uploadImageMark  : true,
                                    deleteImageMark  : true,
                                    putMetaDataMark  : true
                                ]
    
    /// This function is needed for login to the CAN. It uses the users login details to gain access to his images
    /// A successful request loads a json-array with information about the images metadata and origin to download it
    /// - returns: the json-Array as binary information
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
        
        return getImageInfoData
    }
    
    
    /// Uploads an image to the CAN. The body of the request is a JSON text. It holds the images binary data as base64 string
    /// and the images name.
    /// - parameter jsonString: It is the body of the request holding images source data and its name
    /// - parameter sender: is the object which called this method
    /// - returns: true if request succeeded, else false
    static func uploadImage(jsonString: String, sender: GalleryVC) -> Bool{
        
        var request = initRequest(url: uploadLink, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonString.data(using: .utf8)
        
        let sem = DispatchSemaphore(value: 0)
        
        let task = initTask(request: request, semaphore: sem, requestMark: uploadImageMark)
            task.resume()
            sem.wait()        
        
        if failDictionary[uploadImageMark]! {
            return true
        }else{
            failDictionary[uploadImageMark] = true
            return false
        }
    }
    
    
   
    
    /// This will download an image from the backend. The only information the method needs is the link to the image source
    /// - returns: the binary image data
    static func getImage(urlAsString: String) -> Data{
        
        let request = initRequest(url: urlAsString, method: "GET")
       
        let sem = DispatchSemaphore(value: 0)
        let task = initTask(request: request, semaphore: sem, requestMark: getImageMark)
        task.resume()
        
        sem.wait()
        
        return getImageData
    }
    
    /// Method for updating an images metadata
    /// - parameter imageName: is the name of the image. CAN is able to identify it with this information and the request-link
    /// - parameter jsonString: The new metadata information is written in JSON-format
    /// - returns: true if request succeeded, else false
    static func updateMetaData(imageName: String, jsonString: String) -> Bool{
        self.imageName = imageName

        var request = initRequest(url: setMetaDataLink, method: "PUT")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonString.data(using: .utf8)
        
        let sem = DispatchSemaphore(value: 0)
        let task = initTask(request: request, semaphore: sem, requestMark: putMetaDataMark)
        task.resume()
        sem.wait()
        
        if failDictionary[putMetaDataMark]!{
            return true
        } else {
            failDictionary[putMetaDataMark] = true
            return false
        }
    }
    
    
    
    /// Method for deleting an image from the CAN
    /// - parameter imageNames: is a string with comma seperated image names for the query of the request. Example: imageName?name1,name2,name3
    /// - returns: true if request succeeded, else false
    static func deleteImage(imageNames: String) -> Bool{
        
        let deletionLink = "\(self.deletionLink)\(imageNames)"
        
        let request = initRequest(url: deletionLink, method: "DELETE")
        
        let sem = DispatchSemaphore(value: 0)
        let task = initTask(request: request, semaphore: sem, requestMark: deleteImageMark)
        task.resume()
        
        sem.wait()
        
        if failDictionary[deleteImageMark]!{
            return true
        } else {
            failDictionary[deleteImageMark] = true
            return false
        }
    }
    
    /// Every REST-call needs an authorization header. This function will generate a base64 string using username and password.
    /// Furthermore, an URLRequest object is created based on the given link.
    /// Besides that, the request gets a HTTP-method, that means in our case: "GET", "POST", "PUT" or "DELETE"
    /// - parameter url: This is the destination link of the request
    /// - parameter method: This is the HTTP-method of the request, e.g. "GET" or "POST"
    /// - returns: The initialized URLRequest object
    static func initRequest(url: String, method: String) -> URLRequest{
        
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        
        let userNameAndPwBase64 = Utils.encodeStringToBase64(str: "\(userName):\(password)")
        
        request.httpMethod = method
        request.addValue("Basic \(userNameAndPwBase64)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    /// This function initializes the task of a request.
    /// -> Error handling: Deciding what happens if the actual status code is not the expected one.
    /// -> Signaling the sempaphore: Because of the asynchronicity of the requests the method has to be able to wait for the response information.
    /// -> Saving the response data: The data will saved to properties of this class.
    /// - parameter request: Is the URLRequest object for the REST-call
    /// - parameter semaphore: A DispatchSemaphore, allows the waiting for the asynchronous request and its resulting information
    /// - parameter requestMark: This is the number of the request call. Please see class properties for possible values
    /// - returns: The initialized task object for performing a REST-call
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
                print("fail")
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
