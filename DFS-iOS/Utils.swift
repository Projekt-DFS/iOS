import Foundation
import UIKit

class Utils{
    
    
    /**
     Erzeugt eine Toast Message, die folgendermassen aufgerufen wird:
     
     let toastLabel = Utils.showToast(message: "You downloaded 1 pic", width: Double(self.view.frame.size.width), height: Double(self.view.frame.size.height))
     self.view.addSubview(toastLabel)
     UIView.animate(withDuration: 4.0, delay: 0.2, options: .curveEaseIn, animations:{
     toastLabel.alpha = 0.0
     }, completion: {(isCompleted) in
     toastLabel.removeFromSuperview()
     })
     
     der Code hier im Kommentar dient gerade nur zur Erinnerung fuer den spaeteren Aufruf
     und kommt deshalb wieder weg
    */
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
    
    
    /**
     Prueft, ob die Login-Daten eingegeben wurden
    */
    static func checkLoginDetails(name: String, pw: String, ip: String) -> Bool{
        if name == "" || pw == "" || ip == "" {
            return false
        }
        return true
    }
    
    
    
    /**
     Base64 Encoder: String -> Base64 String
    */
    static func encodeStringToBase64(str: String) -> String{
        return Data(str.utf8).base64EncodedString()
    }
    
    /**
     Base64 Encoder: Data -> Base64
    */
    static func encodeDataToBase64(data: Data) -> String{
        return data.base64EncodedString()
    }
    
    
    /**
     Generates the name of an image to get uploaded
    */
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
