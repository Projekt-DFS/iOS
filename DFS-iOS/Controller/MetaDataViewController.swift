//
//  MetaDataViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class MetaDataViewController: UITableViewController {

    @IBOutlet weak var metaDataNavigationItem: UINavigationItem!
    @IBOutlet var metaDataTableView: UITableView!
    
    // keine Ahnung was diese drei Methoden machen sollen
    func getMetaData() {}
    
    func setMetaData() {}
    
    func sendMetaData() {}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

   
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
