import UIKit

/// Controller for the metaData scene.
///
/// - author: Phillip Persch
class MetaDataVC: UIViewController {
    
    
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

    /// Switches the visibility of labels and text fields, depending on which are needed.
    /// If the user wants to edit metadata, text fields should be visible.
    /// If the user wants to view the curren metadata, labels should be visible.
    func switchVisibility() {
        for label in labels { label?.isHidden = !(label?.isHidden)!}
        for textField in textFields { textField?.isHidden = !(textField?.isHidden)!}
    }
    
    /// Refreshes the current view and all of its labels and text fields.
    func refreshView() {
        metaData = image.getMetaData()
        
        ownerLabel.text = metaData.getOwner()
        createdLabel.text = Utils.shortenCreationDate(image: image)
        
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
    
    /// Called after the controller's view is loaded into memory.
    /// Sets the image to be edited to the image that was shown in the image detail scene.
    override func viewDidLoad() {
        super.viewDidLoad()
        image = (galleryVC?.images[(galleryVC?.indexOfImageInDetailView)!])!
        refreshView()
        
    }
        
    
    /// Gets called when the user presses the edit button.
    /// Edits the image's metadata to match the text fields' texts. Then refreshes the view.
    ///
    /// - parameter sender: the button that was pressed
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
            

            if (Communicator.updateMetaData(imageName: image.getImageName(), jsonString: json)) {
                galleryVC?.refreshGallery()
            }
            
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
}
