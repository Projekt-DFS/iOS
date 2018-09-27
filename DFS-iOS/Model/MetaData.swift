import Foundation


/// Wrapper object for additional information about an image.
///
/// - author: Phillip Persch
class MetaData {
    private var owner: String
    private var created: String
    private var location: String
    private var tagList : [String]
    
    /// Initializes a MetaData object.
    ///
    /// - parameter owner: the user who owns the image
    /// - parameter created: the creation time of the image. This can be of type String because
    ///                      it is downloaded from the backend and can not be changed
    /// - parameter location: the location where the image was taken, represented as a String
    /// - parameter tagList: a list of tags the user associates to the image
    init(owner: String, created:String, location: String, tagList:[String]) {
        self.owner = owner
        self.created = created
        self.location = location
        self.tagList = tagList
    }
    
    /// Initializes an empty MetaData object
    init(){
        self.owner    =  ""
        self.created  =  ""
        self.location =  ""
        self.tagList  = [String]()
    }
    
    /// Getter for field owner
    func getOwner() -> String {
        return self.owner
    }
    
    /// Setter for field owner
    func setOwner(newValue: String) {
        self.owner = newValue
    }
    
    /// Getter for field location
    func getLocation() -> String {
        return self.location
    }
    
    /// Setter for field location
    func setLocation(newValue: String) {
        self.location = newValue
    }
    
    /// Getter for field created
    func getCreated() -> String {
        return self.created
    }
    
    /// Setter for field created
    func setCreated(newValue: String) {
        self.created = newValue
    }
    
    /// Getter for field tagList
    func getTagList() -> [String]{
            return tagList
    }
    
    /// Gets the item at a given index of field tagList
    ///
    /// - parameter index: the index of the item
    ///
    /// - returns: the item at the index
    func getTagListAt(index: Int) -> String {
        if self.tagList.count <= index {
            return ""
        }
        
        return self.tagList[index]
    }
    
    /// Adds a value to the tagList.
    ///
    /// - parameter index: the index where the value should be put
    /// - parameter newValue: the new tag
    func appendToTagList(index: Int, newValue: String) {
        if tagList.count < 3 {
        self.tagList.append(newValue)
        } else {
            tagList[index] = newValue
        }
        
    }
}
