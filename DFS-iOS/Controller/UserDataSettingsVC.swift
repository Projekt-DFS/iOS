//
//  SettingsViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class UserDataSettingsVC: UIViewController {

    let userDataSettings = UserDataSettings()
    
    @IBOutlet weak var autoUploadLabel: UILabel!
    @IBOutlet weak var autoUploadSwitch: UISwitch!
    @IBOutlet var settingsView: UserDataSettingsView!
    @IBOutlet weak var settingsNavigationItem: UINavigationItem!
    @IBOutlet weak var logoutBarButton: UIBarButtonItem!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ipTextField: UITextField!
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if let username = usernameTextField.text{
            userDataSettings.setDefaultUserName(username)
        }
        if let password = passwordTextField.text{
            userDataSettings.setDefaultPw(password)
        }
        if let ip = ipTextField.text{
            userDataSettings.setDefaultIp(ip)
        }
        
        usernameTextField.placeholder = usernameTextField.text!
        passwordTextField.placeholder = passwordTextField.text!
        ipTextField.placeholder = ipTextField.text!
        
        usernameTextField.text! = ""
        passwordTextField.text! = ""
        ipTextField.text! = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        autoUploadSwitch.transform = transform
        
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
    
    // method for the Keyboard change
    @objc func keyboardWillChange(notification: Notification){
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            
            view.frame.origin.y = -(keyboardRect.height/3)
        } else {
            view.frame.origin.y = 0
        }
    }
}
