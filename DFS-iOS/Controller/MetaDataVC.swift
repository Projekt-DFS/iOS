//
//  MetaDataViewController.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 09.05.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit

class MetaDataVC: UIViewController {
    
    
    // Variablen
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tagListLabel1: UILabel!
    @IBOutlet weak var tagListLabel2: UILabel!
    @IBOutlet weak var tagListLabel3: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var tagListTextField1: UITextField!
    @IBOutlet weak var tagListTextField2: UITextField!
    @IBOutlet weak var tagListTextField3: UITextField!
    
    @IBOutlet weak var textFieldStack: UIStackView!
    @IBOutlet weak var labelStack: UIStackView!
    
    lazy var labels = [ locationLabel, tagListLabel1, tagListLabel2, tagListLabel3]
    lazy var textFields = [locationTextField, tagListTextField1, tagListTextField2, tagListTextField3]
    
    var galleryVC : GalleryVC?
    var image = Image()
    var metaData = MetaData()
    var editingMode = false {
        didSet{
            labelStack.isHidden = !labelStack.isHidden
            textFieldStack.isHidden = !textFieldStack.isHidden
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image = (galleryVC?.images[(galleryVC?.indexOfImageInDetailView)!])!
        metaData = image.getMetaData()

        ownerLabel.text = metaData.getOwner()
        createdLabel.text = metaData.getCreated()
        locationLabel.text = metaData.getLocation()
        tagListLabel1.text = metaData.getTagListAt(index: 0)
        tagListLabel2.text = metaData.getTagListAt(index: 1)
        tagListLabel3.text = metaData.getTagListAt(index: 2)
        
        locationTextField.placeholder = locationLabel.text
        tagListTextField1.placeholder = tagListLabel1.text
        tagListTextField2.placeholder = tagListLabel2.text
        tagListTextField3.placeholder = tagListLabel3.text
        
        for textField in textFields {
            textField?.text = ""
        }
    }
        
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        if !editingMode {
            editButton.setTitle("Done", for: UIControlState.normal)
        } else {
            editButton.setTitle("Edit Metadata", for: UIControlState.normal)
            for index in 0..<textFields.count {
                if textFields[index]?.text != "" {
                    labels[index]?.text = textFields[index]?.text
                }
            }
            let tags = "\"\(tagListLabel1.text ?? "")\", \"\(tagListLabel2.text ?? "")\", \"\(tagListLabel3.text ?? "")\""
            
            let json = "{\n\t\"location\":\"\(locationLabel.text ?? "")\",\n\"tagList\":[\(tags)]\n}"
            
            print(tags + "\n")
            print(json)
            Communicator.updateMetaData(imageName: image.getImageName(), jsonString: json)
            
            print("name:" + image.getImageName() + "\n")
            print("created:" + image.getMetaData().getCreated() + "\n")
            print("user:" + image.getMetaData().getOwner() + "\n")
            
        }
        

        editingMode = !editingMode
        viewDidLoad()
    }
    
    
    func organizeTagListLabels() {
        //TODO: Schöner ausrichten, wenn Einträge entfernt/hinzugefügt werden
    }
    

    
    



}
