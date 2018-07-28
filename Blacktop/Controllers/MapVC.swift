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
    @IBOutlet weak var cafeCalloutView: UIView!
    @IBOutlet weak var cafeCalloutName: UILabel!
    @IBOutlet weak var cafeCalloutAddress: UILabel!
    @IBOutlet weak var cafeCalloutCityStateZip: UILabel!
    @IBOutlet weak var cafeCalloutPhone: UILabel!
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    var cafeID = ""
    
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        cafeCalloutView.isHidden = true
        mapView.delegate = self
        locationManager.delegate = self
        confirmAuthorization()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cafePins()
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        ref.child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (Snapshot) in
            let data = Snapshot.value as! [String: Any]
            let userRole = data["role"] as! String
            
            if userRole == "cafe" {
                let cafeVC = self.storyboard?.instantiateViewController(withIdentifier: "CafeVC") as? CafeVC
                cafeVC?.initData(uid: (Auth.auth().currentUser?.uid)!)
                self.present(cafeVC!, animated: true, completion: nil)
            } else {
                let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC")
                self.present(profileVC!, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func viewCafePressed(_ sender: Any) {
        let cafeVC = self.storyboard?.instantiateViewController(withIdentifier: "CafeVC") as? CafeVC
        cafeVC?.initData(uid: cafeID)
        self.present(cafeVC!, animated: true, completion: nil)
        
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
                guard let address = cafeData.childSnapshot(forPath: "location/address").value as? String,
                    let city = cafeData.childSnapshot(forPath: "location/city").value as? String,
                    let state = cafeData.childSnapshot(forPath: "location/state").value as? String,
                    let zipcode = cafeData.childSnapshot(forPath: "location/zipcode").value as? String,
                    let name = cafeData.childSnapshot(forPath: "name").value as? String,
                    let phoneNumber = cafeData.childSnapshot(forPath: "phone").value as? String else { continue }
                
                    let cafeID = cafeData.key
                
                if address != "" && city != "" && state != "" && zipcode != "" {
                    let cafeAddress = "\(address) \(city) \(state) \(zipcode)"
                    let geoCoder = CLGeocoder()
                    geoCoder.geocodeAddressString(cafeAddress, completionHandler: { (cafeLocation, error) in
                        let location = cafeLocation?.first?.location?.coordinate
                        let annotation = CafeAnnotation(coordinate: location!, uid: cafeID, name: name, address: address, city: city, state: state, zipcode: zipcode, phoneNumber: phoneNumber)
                        self.mapView.addAnnotation(annotation)
                    })
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        if annotationView == nil {
            annotationView = CafeAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "coffee")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation { return }
        
        let cafeAnnotation = view.annotation as! CafeAnnotation

        cafeCalloutName.text = cafeAnnotation.name
        cafeCalloutAddress.text = cafeAnnotation.address
        cafeCalloutCityStateZip.text = "\(cafeAnnotation.city), \(cafeAnnotation.state) \(cafeAnnotation.zipcode)"
        cafeCalloutPhone.text = cafeAnnotation.phoneNumber
        cafeID = cafeAnnotation.uid
        cafeCalloutView.isHidden = false

        let coordinateRegion = MKCoordinateRegionMakeWithDistance((view.annotation?.coordinate)!, regionRadius * 2, regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        cafeCalloutView.isHidden = true
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
