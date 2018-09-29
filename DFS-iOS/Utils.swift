import Foundation
import UIKit


/// Utils is a helper class for different tasks. The methods commentary will explain it more detailed
/// - author: Phillip Persch, Julian Einspenner
class Utils{

    /// Generates a toast message. Its values are given as parameters
    /// - parameter message: The message the toast shows
    /// - parameter width: is the width of the message container shown on the devices screen
    /// - parameter height: is the height of the message container shown on the devices screen
    /// - returns: the toastLabel with message and dimension
    static func generateToast(message: String, width: Double, height: Double) -> UILabel{
        let toastLabel = UILabel(frame: CGRect(x: width / 2 - 125, y: height - 100, width: 250, height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 12
        toastLabel.clipsToBounds = true
        
        return toastLabel
    }
    
    
    /// Checks if the login details are typed correctly
    /// - parameter name: the typed username
    /// - parameter pw: the typed password
    /// - parameter ip: the typed ip-adress
    /// - returns: true if valid input, else false
    static func checkLoginDetails(name: String, pw: String, ip: String) -> Bool{
        if name == "" || pw == "" || ip == "" {
            return false
        }
        return true
    }
    
    
    
    /// Converts a string to base64-format
    /// - parameter str: is the string which is going to be converted to base64
    /// - returns: the encoded string
    static func encodeStringToBase64(str: String) -> String{
        return Data(str.utf8).base64EncodedString()
    }
    
    /// Converts binary data to a base64 string. This is needed for uploading images
    /// - parameter data: is the binary data of an image
    /// - returns: the base64 encoded binary data
    static func encodeDataToBase64(data: Data) -> String{
        return data.base64EncodedString()
    }
    
    /// Generates a random name for an image.
    /// Structure: IMG_ + Month + Day + Year + RandomNumber + .jpg
    /// - returns: the image name with the structure
    static func generateImageName() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        var str = formatter.string(from: Date())
        str = str.replacingOccurrences(of: ".", with: "")
        str = str.replacingOccurrences(of: ", ", with: "_")
        str = str.replacingOccurrences(of: ":", with: "")
        
        str = "\(str)_\(arc4random() % 1000)"
        
        return "IMG_\(str).jpg"
    }
    
    /// Shortens the String of the creation date received from the backend.
    /// Since this app stores the creation time as a String, while the backend uses java type Date sends its toString(),
    /// the received String is too long and detailed.
    /// In order to fit the screen size and only display year, month and day, it needs to be shortened.
    ///
    /// - parameter image: the image of which the creation date needs to be shortened
    /// - returns: the shortened version of a images date
    static func shortenCreationDate(image: Image) -> String {
        let created = image.getMetaData().getCreated()
        let indexEnd = created.index(created.endIndex, offsetBy: -13)
        return String(created[..<indexEnd])
    }
    
    
    /// Takes an image's creation date and calculates the number of seconds since January 1 1970.
    /// This is important for ordering images by creation time.
    ///
    /// Note: This would have been easier, if we had used a proper Date type instead of String.
    /// It is too late to change it though.
    ///
    /// - parameter image: the image
    /// - returns: the time difference in seconds between the image's creation time and January 1 1970
    static func secondsSince1970(image: Image) -> Double {
        let shortenedDate = image.getMetaData().getCreated().replacingOccurrences(of: "T", with: "-")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.SSS"
        let date = dateFormatter.date(from: shortenedDate)

        return Double((date?.timeIntervalSince1970) ?? 0.0)
    }
        
}
