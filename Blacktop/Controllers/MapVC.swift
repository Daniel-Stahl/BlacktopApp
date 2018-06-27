//
//  MapVC.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/18/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapVC: UIViewController {
    var ref: DatabaseReference!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var cafe: Cafe?
    
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        mapView.delegate = self
        locationManager.delegate = self
        confirmAuthorization()
        //cafePins()
        getCafeData()
        configureCafeInMap()
    }
    
    func getCafeData() {
        ref.child("users").observe(.value) { (snapshot) in
            let value = snapshot.value as? [String: Any]
            let address = value!["name"]
            print(address)
            self.cafe = Cafe(dictionary: value!)
        }
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        configureCafeInMap()
//    }
    
    @IBAction func centerUserLocationButton(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
}

extension MapVC: MKMapViewDelegate {
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2, regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func configureCafeInMap() {
        
//        var annotations = [MKAnnotation]()
        let coordinate = cafe?.location
//        let annotation = CafeAnnotation(coordinate: coordinate!)
//        annotations.append(annotation)
//        self.mapView.addAnnotations(annotations)
        print(coordinate)
    }
    
//    func cafePins() {
//        ref.child("users").observe(.value) { (Datasnapshot) in
//            guard let data = Datasnapshot.children.allObjects as? [DataSnapshot] else { return }
//            for cafeData in data {
//                guard let address = cafeData.childSnapshot(forPath: "location/address").value as? String else { continue }
//                guard let city = cafeData.childSnapshot(forPath: "location/city").value as? String else { continue }
//                guard let state = cafeData.childSnapshot(forPath: "location/state").value as? String else { continue }
//                guard let zipcode = cafeData.childSnapshot(forPath: "location/zipcode").value as? String else { continue }
//                guard let name = cafeData.childSnapshot(forPath: "name").value as? String else { continue }
//
//                if address != "" && city != "" && state != "" && zipcode != "" {
//                    let cafeAddress = "\(address) \(city) \(state) \(zipcode)"
//                    let geoCoder = CLGeocoder()
//                    geoCoder.geocodeAddressString(cafeAddress, completionHandler: { (cafeLocation, error) in
//                        let location = cafeLocation?.first?.location?.coordinate
//                        let annotation = CafeAnnotation(cafeName: name, coordinate: location!)
//                        self.mapView.addAnnotation(annotation)
//                    })
//                }
//            }
//        }
//    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        print(view)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print(view)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "customCafeView")

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "customCafeView")
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation { return nil }
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: kPersonWishListAnnotationName)
//
//        if annotationView == nil {
//            annotationView = PersonWishListAnnotationView(annotation: annotation, reuseIdentifier: kPersonWishListAnnotationName)
//            (annotationView as! PersonWishListAnnotationView).personDetailDelegate = self
//        } else {
//            annotationView!.annotation = annotation
//        }
//        return annotationView
//    }
    
}

extension MapVC: CLLocationManagerDelegate {
    func confirmAuthorization() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
}
