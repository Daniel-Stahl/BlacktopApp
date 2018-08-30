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
    @IBAction func unwindFromCafeVC(segue:UIStoryboardSegue) { }
    
    var cafe = [Cafe]()
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

//        FirebaseService.instance.getCafeData { (returnedCafe) in
//            self.cafe = returnedCafe
//            self.cafePins()
//        }
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        DispatchQueue.global(qos: .background).async {
            self.ref.child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (Snapshot) in
                let data = Snapshot.value as! [String: Any]
                let userRole = data["role"] as! String
                
                DispatchQueue.main.async {
                    if userRole == "cafe" {
                        let cafeVC = self.storyboard?.instantiateViewController(withIdentifier: "CafeVC") as? CafeVC
                        cafeVC?.initData(uid: (Auth.auth().currentUser?.uid)!)
                        self.present(cafeVC!, animated: true, completion: nil)
                    } else {
                        self.performSegue(withIdentifier: "toProfileVC", sender: nil)
                    }
                }
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
            locationManager.requestLocation()
            centerMapOnUserLocation()
        }
    }
}

extension MapVC: MKMapViewDelegate {
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2, regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        FirebaseService.instance.getCafeData { (returnedCafe) in
            self.cafe = returnedCafe
            self.cafePins()
        }
    }
    
    func cafePins() {
        for data in cafe {
            if data.address != "" && data.city != "" && data.state != "" && data.zipcode != "" {
                let cafeAddress = "\(data.address) \(data.city) \(data.state) \(data.zipcode)"
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(cafeAddress, completionHandler: { (cafeLocation, error) in
                    if let location = cafeLocation?.first?.location?.coordinate {
                        let annotation = CafeAnnotation(coordinate: location, uid: data.key, name: data.name, address: data.address, city: data.city, state: data.state, zipcode: data.zipcode, phoneNumber: data.phone)
                        self.mapView.addAnnotation(annotation)
                    }
                })
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
            locationManager.requestWhenInUseAuthorization()
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Found user's location: \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}
