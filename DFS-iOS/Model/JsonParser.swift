import Foundation

/// JSON-Data received from the CAN has to be parsed in a format which this application can use
/// for creating images, show metadata, and extract request links with information about the image source
/// - author: Julian Einspenner
class JsonParser{
    
    /// A data object coming from the CAN will be transformed to a json object via extracJsonDataFromImageContainer()
    /// Afterwards, this json object will converted to an image object with many information, such as the full image
    /// source link, thumbnail link, metadata and so on (see Image class).
    /// For each element of the json object one image object will be created and stored to an image array
    /// - parameter data: is the binary data received from the CAN backend
    /// - returns: the image array
    static func parseFromJsonToImageArray(data: Data) -> [Image]{
        let json = extractJsonDataFromImageContainer(data)
        var imageArray = [Image]()
        
        for container in json{
            let img = Image(json: container)
            imageArray.append(img)
        }
        
        return imageArray
    }
    
    /// Uses a method from Swift 4 standard api to convert binary data to a json file.
    /// The file is from type [[String:Any]], that means an array of dictionaries.
    /// Within this data structure it is possible to store the images information
    /// - parameter data: binary data, will be converted to JSON
    /// - returns: a json object with data structure [[String:Any]]
    static func extractJsonDataFromImageContainer(_ data: Data) -> [[String: Any]] {
        
        do{
            guard let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
                return [["":""]]
            }
            return jsonData
        }catch let jsonErr{
            print(jsonErr)
            return [["":""]]
        }
    }
    
}


