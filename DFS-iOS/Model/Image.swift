import Foundation

/// An object containing all the necessary information to manage images in this application.
/// It contains a source (URL), a name, a source for a downscaled thumbnail, and the according metadata.
///
/// - author: Phillip Persch, Julian Einspenner
class Image {
    
    
    private let imageName    : String
    private let imageSource  : String
    private let thumbnail    : String
    private var metaData     : MetaData
        
    
    /// Initializes an image object.
    ///
    /// - parameter imageName: the new name
    /// - parameter imageSource: the URL where it can be found
    /// - parameter thumbnail: the URL of the thumbnail
    /// - parameter meteData: additional information wrapped in a MetaData object
    init(imageName: String, imageSource: String, thumbnail: String, metaData: MetaData) {
        self.imageName = imageName
        self.imageSource = imageSource
        self.thumbnail = thumbnail
        self.metaData = metaData
    }
    
    
    /// Initializes an empty image object.
    init(){
        self.imageName = ""
        self.imageSource = ""
        self.thumbnail = ""
        self.metaData = MetaData(owner: "", created: "", location: "", tagList: [String()])
    }
    
    
    /// Initializes an image object using JSON formatted Strings
    ///
    /// - parameter json: a dictionary containing the necessary information in JSON format.
    init(json: [String: Any]){
        imageName     =  json["imageName"   ]      as?  String          ??  ""
        imageSource   =  json["imageSource" ]      as?  String          ??  ""
        thumbnail     =  json["thumbnail"   ]      as?  String          ??  ""
        
        
        let jsonMeta      =  json["metaData"    ]      as?  [String:Any]        ??  ["":""]
        let owner = jsonMeta["owner"]!
        let created = jsonMeta["created"]!
        
        var location = String()
        if let locationTmp = jsonMeta["location"] as? String{
            location = locationTmp
        }
        
        var tagList = [String()]
        if let tagListTmp = jsonMeta["tagList"] as? [String]{
            tagList = tagListTmp
        }
        
        metaData = MetaData(owner: owner as! String, created: created as! String, location: location, tagList: tagList)
        
    }
    
    /// Getter for field imageName
    public func getImageName() -> String{
        return self.imageName
    }
    
    /// Getter for field thumbnail
    public func getThumbnail() -> String {
        return self.thumbnail
    }
    
    /// Getter for field imageSource
    public func getImageSource() -> String {
        return self.imageSource
    }
    
    /// Getter for field metaData
    public func getMetaData() -> MetaData {
        return self.metaData
    }
    
    /// Setter for field metaData
    public func setMetaData(metaData: MetaData) {
        self.metaData = metaData
    }
    
    
}
