import Foundation

class JsonParser{
    
    static func parseFromJsonToImageArray(data: Data) -> [Image]{
        let json = extractJsonDataFromImageContainer(data)
        var imageArray = [Image]()
        
        for container in json{
            let img = Image(json: container)
            imageArray.append(img)
        }
        
        return imageArray
    }
    
    
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


