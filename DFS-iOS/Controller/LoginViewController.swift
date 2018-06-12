//
//  LoginViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func logIn(_ sender: UIButton) {
        
        //die if-Abfrage ergibt  zur Zeit immer true!
        //in logIn() gibt es die Antwort der Login-Request. Dort drin
        //sind aktuell die thumbnails und die Vollbilder als Base64-String
        //wir muessen klaeren, was damit passiert und wann es passiert
        if Communicator.logIn(){
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
        else{
            print("Login failed")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
