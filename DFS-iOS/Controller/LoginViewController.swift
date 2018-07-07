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
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var ipTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberSwitch: UISwitch!
    
    
    static var imageArray = [Image]()
    

    
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
        
        if let images = Communicator.getImageInfo(){
            LoginViewController.imageArray = images
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
        else{
            let toastLabel = Utils.generateToast(message: "Login failed", width: Double(self.view.frame.size.width), height: Double(self.view.frame.size.height))
            
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 0.2, options: .curveEaseIn, animations:{
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
            print("Login failed")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            let destinationVC = segue.destination as! UINavigationController
            let galleryVC = destinationVC.childViewControllers[0] as! GalleryCollectionViewController
            galleryVC.gallery = Gallery(images: LoginViewController.imageArray)
            galleryVC.loginVC = self
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextFieldsIfDataRemebered()
    }
    
}
