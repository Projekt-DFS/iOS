import UIKit

/// Controller for the login scene.
///
/// - author: Phillip Persch, Julian Einspenner
class LoginVC: UIViewController {
    
    let uds = UserDataSettings()
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var ipTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberSwitch: UISwitch!
   
    /// Method for storing default user details to the application storage.
    /// see UserDataSettings - class for further information
    func setData(){
        if let userName = userNameTextField.text{
            uds.setDefaultUserName(userName)
        }
        
        if let pw = passwordTextField.text{
            uds.setDefaultPw(pw)
        }
        if let ip = ipTextField.text{
            uds.setDefaultIp(ip)
        }
    }
    
    /// Attempts to login and initiates the following actions.
    /// If the login attempt is successfull, it navigates to the gallery scene showing the user's images.
    /// If the login attempt fails, the user is informed.
    ///
    /// - parameter sender: the button that was clicked
    @IBAction func logIn(_ sender: UIButton) {
        if rememberSwitch.isOn{
            setData()
        }else{
            uds.resetUserDefaults()
        }
        
        if(userNameTextField.text != "" && passwordTextField.text != "" && ipTextField.text != ""){
            Communicator.userName = userNameTextField.text!
            Communicator.password = passwordTextField.text!
            Communicator.ip       = ipTextField.text!
        }else{
            return
        }
        
        if let _ = Communicator.getImageInfo(){
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
        else{
            let toastLabel = Utils.generateToast(message: "Login failed", width: Double(self.view.frame.size.width), height: Double(self.view.frame.size.height))
            
            // in case of a failed login attempt, a toast is shown, informing the user of failure
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 0.2, options: .curveEaseIn, animations:{
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
            print("Login failed")
        }
    }
    
    /// Uses the user defaults to fill the login screen textfields with user details
    /// See UserDataSettings - class
    func updateTextFieldsIfDataRemebered(){
        if uds.getDefaultUserName() != ""{
            userNameTextField.text = uds.getDefaultUserName()
        }
        if uds.getDefaultPw() != ""{
            passwordTextField.text = uds.getDefaultPw()
        }
        if uds.getDefaultIp() != ""{
            ipTextField.text = uds.getDefaultIp()
        }
    }
    
    /// Called after the controller's view is loaded into memory.
    /// Sets up the controller's view, including loading user defaults, resizing UI elements, checking for keyboard events
    /// and reorganizing the screen accordingly.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // resize UISwitch
        let transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        rememberSwitch.transform = transform
        
        
        updateTextFieldsIfDataRemebered()
        
        // Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

    }
    
    /// Method to reorganize UI when a keyboard slides onto the screen.
    /// This is necessary in order to keep important UI elements visible.
    ///
    /// - parameter notification: the notification of a keyboard sliding onto the screen or leaving it
    @objc func keyboardWillChange(notification: Notification){
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            
            view.frame.origin.y = -(keyboardRect.height/2)
        } else {
             view.frame.origin.y = 0
        }
            
    }
    
    /// Empty implementation of an unwind segue. This is necessary in order to perform a logout from UserDataSettingsVC.
    ///
    /// - parameter segue: the segue that handles the logout navigation
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){}

    
}
