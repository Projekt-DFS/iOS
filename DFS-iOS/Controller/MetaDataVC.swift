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

    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tagListLabel1: UILabel!
    @IBOutlet weak var tagListLabel2: UILabel!
    @IBOutlet weak var tagListLabel3: UILabel!
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var tagListTextField1: UITextField!
    @IBOutlet weak var tagListTextField2: UITextField!
    @IBOutlet weak var tagListTextField3: UITextField!
    
    
    lazy var labels = [ locationLabel, tagListLabel1, tagListLabel2, tagListLabel3]
    lazy var textFields = [locationTextField, tagListTextField1, tagListTextField2, tagListTextField3]
    
    var galleryVC : GalleryVC?
    var image = Image()
    var metaData = MetaData()
    var editingMode = false {
        didSet{
            switchVisibility()
        }
    }

    func switchVisibility() {
        for label in labels { label?.isHidden = !(label?.isHidden)!}
        for textField in textFields { textField?.isHidden = !(textField?.isHidden)!}
    }
    
    func refreshView() {
        metaData = image.getMetaData()
        
        ownerLabel.text = metaData.getOwner()
        
        let created = metaData.getCreated()
        let indexEnd = created.index(created.endIndex, offsetBy: -13)
        createdLabel.text = String(created[..<indexEnd])
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image = (galleryVC?.images[(galleryVC?.indexOfImageInDetailView)!])!
        refreshView()
        
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
            
            let json = "{\n\t\"location\":\"\(locationLabel.text ?? "")\",\n\t\"tagList\":[\(tags)]\n}"
            

            Communicator.updateMetaData(imageName: image.getImageName(), jsonString: json)
            
            if locationTextField.hasText {
                metaData.setLocation(newValue: locationTextField.text ?? "")
            }
            if tagListTextField1.hasText {
                metaData.appendToTagList(index: 0, newValue: tagListTextField1.text ?? "")
            }
            if tagListTextField2.hasText {
                metaData.appendToTagList(index: 1, newValue: tagListTextField2.text ?? "")
            }
            if tagListTextField3.hasText {
                metaData.appendToTagList(index: 2, newValue: tagListTextField3.text ?? "")
            }
        }
        

        editingMode = !editingMode
        refreshView()
    }
    
    
    func organizeTagListLabels() {
        //TODO: Schöner ausrichten, wenn Einträge entfernt/hinzugefügt werden
    }
    

    
    



}
