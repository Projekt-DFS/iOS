//
//  MapVC.swift
//  DFS-iOS
//
//  Created by Konrad Zuse on 06.08.18.
//  Copyright © 2018 philp_sc. All rights reserved.
//

import UIKit
import MapKit


class MapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var galleryVC = GalleryVC()
    var imagesByLocation = [CLPlacemark : [Image]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsCompass = true
        mapView.region.span = MKCoordinateSpan(latitudeDelta: 128, longitudeDelta: 96)
        setAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setAnnotations()
    }
    
   
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
    }
    
    private func setAnnotations() {
        let navVC = tabBarController?.childViewControllers[0] as! NavigationVC
        galleryVC = navVC.childViewControllers[0] as! GalleryVC
        for image in galleryVC.images {
            let location = image.getMetaData().getLocation()
            if location != "" {
                setAnnotation(location, for: image)
        }
    }
    
    
    }
    private func setAnnotation(_ location: String, for image: Image) {
        let geocoder: CLGeocoder = CLGeocoder()
        print("setAnnotation called for \(location)")
        
        geocoder.geocodeAddressString(location,completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let count = placemarks?.count {
                if count > 0 {
                    let topResult: CLPlacemark = placemarks![0]
                    let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                    self.mapView.addAnnotation(placemark)
                    self.imagesByLocation[placemark]?.append(image)
                }
            }
        })
    }

}
