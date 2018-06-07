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
    
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        mapView.delegate = self
        locationManager.delegate = self
        confirmAuthorization()
        cafePins()
    }
    
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
    
    func cafePins() {
        ref.child("users").observe(.value) { (Datasnapshot) in
            guard let data = Datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            for cafeData in data {
                guard let address = cafeData.childSnapshot(forPath: "address").value as? String else { continue }
                guard let city = cafeData.childSnapshot(forPath: "city").value as? String else { continue }
                guard let state = cafeData.childSnapshot(forPath: "state").value as? String else { continue }
                guard let zipcode = cafeData.childSnapshot(forPath: "zipcode").value as? Int else { continue }
                
                print("\(address)\(city)\(state)\(zipcode)")
//                let geoCoder = CLGeocoder()
//                geoCoder.geocodeAddressString(address, completionHandler: { (cafeLocation, error) in
//                    let location = cafeLocation?.first?.location
//                    let annotation = MKPointAnnotation()
//                    let pinDrop = [location]
//                    for location in pinDrop {
//                        annotation.coordinate = (location?.coordinate)!
//                        self.mapView.addAnnotation(annotation)
//                    }
//                })
            }
        }
    }
    
    
    
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
