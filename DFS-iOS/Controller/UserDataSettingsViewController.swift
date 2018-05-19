//
//  SettingsViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class UserDataSettingsViewController: UIViewController {

    @IBOutlet weak var autoUploadLabel: UILabel!
    @IBOutlet weak var autoUploadSwitch: UISwitch!
    @IBOutlet var settingsView: UserDataSettingsView!
    @IBOutlet weak var settingsNavigationItem: UINavigationItem!
    @IBOutlet weak var logoutBarButton: UIBarButtonItem!
    
    // was macht das?
    func updateSettings() {}
    
    func getSettings() {
        //unnötig?
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Hier muss das Segue zum LoginViewController gecoded werden.
        // User abmelden + Segue ohne ZurückButton + Alle Controller in DFSNavigationController resetten
    }
   

}
