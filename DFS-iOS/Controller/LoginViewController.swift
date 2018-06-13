//
//  LoginViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let uds = UserDataSettings()
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var ipTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    static var imageArray = [Image]()
    
    
    @IBAction func setDataButtonTapped(_ sender: UIButton) {
        
        if let userName = userNameTextField.text{
            uds.setDefaultUserName(userName)
        }
        
        if let pw = passwordTextField.text{
            uds.setDefaultPw(pw)
        }
        if let ip = ipTextField.text{
            uds.setDefaultIp(ip)
        }
        
        updateLabel()
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        
        if let images = Communicator.logIn(userName: uds.getDefaultUserName(), password: uds.getDefaultPw(), ip: uds.getDefaultIp()) {
            LoginViewController.imageArray = images
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
        else{
            print("Login failed")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            let destinationVC = segue.destination as! UINavigationController
            let galleryVC = destinationVC.childViewControllers[0] as! GalleryCollectionViewController
            galleryVC.gallery = Gallery(images: LoginViewController.imageArray)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
    }
    
    func updateLabel(){
        loginLabel.text = "Username: \(uds.getDefaultUserName())\nPassword: \(uds.getDefaultPw())\nIP: \(uds.getDefaultIp())"
    }
    
    
    
}
