//
//  SettingsViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class UserDataSettingsViewController: UIViewController {

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
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Hier muss das Segue zum LoginViewController gecoded werden.
        // User abmelden + Segue ohne ZurückButton + Alle Controller in DFSNavigationController resetten
    }
   

}
