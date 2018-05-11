//
//  GalleryViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class GalleryViewController: UITableViewController {

    var gallery: Gallery?
    
    @IBOutlet weak var settingsBarButton: UIBarButtonItem!
    @IBOutlet var thumbnailButtons: [UIButton]!
    @IBOutlet weak var galleryViewNavigationItem: UINavigationItem!
    // @IBOutlet var thumbnails: [UIImage]!
    
    @IBOutlet weak var selectBarButton: UIBarButtonItem!
    @IBOutlet weak var uploadBarButton: UIBarButtonItem!
    
    var trashBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
    var downloadBarButtonItem = UIBarButtonItem(title: "Download", style: UIBarButtonItemStyle.plain, target: self, action: nil)
    var leftBarButtonsAreVisible = false
    
    @IBAction func selectBarButtonPressed(_ sender: UIBarButtonItem) {
        if leftBarButtonsAreVisible == false {
            selectBarButton.title = "Done"
            self.galleryViewNavigationItem.leftBarButtonItems = [trashBarButtonItem, downloadBarButtonItem]
            leftBarButtonsAreVisible = true
        }
        else {
            selectBarButton.title = "Select"
            self.galleryViewNavigationItem.leftBarButtonItems = [uploadBarButton]
            leftBarButtonsAreVisible = false
        }
    }
    
    func showGallery() {}
    
    func refreshGalleryViewFromModel() {
        //Gibts was neues vom Model? Wenn ja, update die View
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Arbeitsspeicher bisschen aufräumen? Thumbnails serialisieren und später wieder in RAM laden?
    }

   
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
