import Foundation

/// This class is responsible to administrate the users login details and the ip adress of the backend.
/// It is possible to store the information to the applications user default storage.
/// Saving the information achieve a better user-GUI - interaction. Once the details are saved, they will not have to
/// be typed by the user again. The class enables a comfortable use of the login screen.
/// - author: Julian Einspenner
class UserDataSettings  {
    
    //-----Properties-----//
    
    //Login and IP
    var userName   = ""
    var pw         = ""
    var ip         = ""
    
    //User Defaults and keys
    let defaults = UserDefaults.standard
    let userNameKey    = "userName"
    let pwKey          = "pw"
    let ipKey          = "ip"
    
    // Initializer. loadDefaultsIfSet() is called
    init() {
        loadDefaultsIfSet()
    }
    
    
    /// Checks, if there are user details already stored to the applications storage. If so, the class properties will be initialized.
    /// If not, the default value "" will be set to userName, pw and ip
    func loadDefaultsIfSet(){
        if let userName = defaults.object(forKey: userNameKey) as? String{
            self.userName = userName
        }
        
        if let pw = defaults.object(forKey: pwKey) as? String {
            self.pw  = pw
        }
        
        if let ip = defaults.object(forKey: ipKey) as? String {
            self.ip = ip
        }
        
    }
    
    
    /// Method to reset userDefaults
    func resetUserDefaults(){
        setDefaultIp("")
        setDefaultPw("")
        setDefaultUserName("")
    }
    
    /// The default username will be set to ""
    /// - parameter to: is the new string which is stored for the user default "userName"
    func setDefaultUserName(_ to: String){
        defaults.set(to, forKey: userNameKey)
    }
    
    /// The default password will be set to ""
    /// - parameter to: is the new string which is stored for the user default "password"
    func setDefaultPw(_ to: String){
        defaults.set(to, forKey: pwKey)
    }
    
    /// The default IP will be set to ""
    /// - parameter to: is the new string which is stored for the user default "IP"
    func setDefaultIp(_ to: String){
        defaults.set(to, forKey: ipKey)
    }
    
    /// If a default username is stored, the method returns it
    /// - returns: the default username
    func getDefaultUserName() -> String{
        if let userName = defaults.object(forKey: userNameKey) as? String {
            return userName
        }else{
            return ""
        }
    }
    
    /// If a default password is stored, the method returns it
    /// - returns: the default password
    func getDefaultPw() -> String{
        if let password = defaults.object(forKey: pwKey) as? String {
            return password
        }else{
            return ""
        }
    }
    
    /// If a default IP is stored, the method returns it
    /// - returns: the default IP
    func getDefaultIp() -> String{
        if let ip = defaults.object(forKey: ipKey) as? String {
            return ip
        }else{
            return ""
        }
    }
    
}
