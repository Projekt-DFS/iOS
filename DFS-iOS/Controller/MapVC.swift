import UIKit
import MapKit

/// Controller for the map scene.
///
/// - author: Phillip Persch

class MapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var galleryVC = GalleryVC()
    
    /// Called after the controller's view is loaded into memory.
    /// Initializes the map view.
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsCompass = true
        mapView.region.span = MKCoordinateSpan(latitudeDelta: 120, longitudeDelta: 90)
    }
    
    /// Sets the correct annotations on the map.
    /// The difference to viewDidLoad() is that this method always gets called when the scene is displayed,
    /// whereas viewDidLoad() only gets called when the controller gets initialized.
    override func viewWillAppear(_ animated: Bool) {
        setAnnotations()
    }
    
    /// Empty implementation of the function that handles the selection of an annotation.
    /// The selection of annotations has no effect in the current state of the app.
    /// This is necessary to implement the protocol MKMapViewDelegate.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    }
    
    /// Empty implementation of the function that handles the deselction of an annotation.
    /// This is necessary to implement the protocol MKMapViewDelegate.
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
    }
    
    /// Sets annotations for all images that have a non-empty location.
    /// Therefore it injects the current controller of the gallery scene and iterates through its images.
    private func setAnnotations() {
        let navVC = tabBarController?.childViewControllers[0] as! UINavigationController
        galleryVC = navVC.childViewControllers[0] as! GalleryVC
        for image in galleryVC.images {
            let location = image.getMetaData().getLocation()
            if location != "" {
                setAnnotation(location)
            }
        }
    }
    
    /// Sets the annotation to the correct spot on the map.
    /// Somewhat unreliable.
    ///
    /// - parameter location: the location attribute of the image's metaData object.
    /// - parameter Image: the
    private func setAnnotation(_ location: String) {
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location,completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let count = placemarks?.count {
                if count > 0 {
                    let topResult: CLPlacemark = placemarks![0]
                    let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                    self.mapView.addAnnotation(placemark)
                }
            }
        })
    }

}
