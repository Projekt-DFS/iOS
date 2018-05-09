//
//  SettingsViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var settings: Settings?
    @IBOutlet weak var autoUploadLabel: UILabel!
    @IBOutlet weak var autoUploadSwitch: UISwitch!
    @IBOutlet var settingsView: SettingsView!
    @IBOutlet weak var settingsNavigationItem: UINavigationItem!
    @IBOutlet weak var logoutBarButton: UIBarButtonItem!
    
    func updateSettings() {}
    
    func getSettings() {
        //unnötig?
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
   

}
