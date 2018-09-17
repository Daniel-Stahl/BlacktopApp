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
import AnyFormatKit

class MapVC: UIViewController {
    var ref: DatabaseReference!
    var cafes = [Cafe]()
    var cafeID = ""
    
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cafeCalloutView: UIView!
    @IBOutlet weak var cafeCalloutName: UILabel!
    @IBOutlet weak var cafeCalloutAddress: UILabel!
    @IBOutlet weak var cafeCalloutCityStateZip: UILabel!
    @IBOutlet weak var cafeCalloutPhone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        cafeCalloutView.isHidden = true
        mapView.delegate = self
        locationManager.delegate = self
        confirmAuthorization()
        
        DatabaseService.instance.getCafeData { (returnedCafe) in
            self.cafes = returnedCafe
            self.cafePins()
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        DatabaseService.instance.getCafeData { (returnedCafe) in
//            self.cafes = returnedCafe
//            self.cafePins()
//        }
//    }
    
    @IBAction func unwindFromCafeVC(segue:UIStoryboardSegue) { }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(currentUser).observeSingleEvent(of: .value) { (Snapshot) in
            DispatchQueue.main.async {
            guard let data = Snapshot.value as? [String: Any],
                let userRole = data["role"] as? String else { return }
                if userRole == "cafe" {
                    guard let cafeVC = self.storyboard?.instantiateViewController(withIdentifier: "CafeVC") as? CafeVC else { return }
                    cafeVC.initData(uid: currentUser)
                    self.present(cafeVC, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "toProfileVC", sender: nil)
                }
            }
        }
    }
    
    @IBAction func viewCafePressed(_ sender: Any) {
        guard let cafeVC = self.storyboard?.instantiateViewController(withIdentifier: "CafeVC") as? CafeVC else { return }
        cafeVC.initData(uid: cafeID)
        self.present(cafeVC, animated: true, completion: nil)
    }
    
    @IBAction func centerUserLocationButton(_ sender: Any) {
        if locationManager.location == nil {
            changeSettingsAlert()
        } else {
            centerMapOnUserLocation()
        }
    }
    
    func changeSettingsAlert() {
        let alert = UIAlertController(title: "Access to location denied", message: "please change your settings in Privacy > Location Services > Blacktop", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (_) in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Setting is opened: \(success)")
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension MapVC: MKMapViewDelegate {
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2, regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
//        locationManager.stopUpdatingLocation()
    }
    
//    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
//        DatabaseService.instance.getCafeData { (returnedCafe) in
//            self.cafes = returnedCafe
//            self.cafePins()
//        }
//    }
    
    func cafePins() {
        for data in cafes {
            if data.address != "" && data.city != "" && data.state != "" && data.zipcode != "" {
                let cafeAddress = "\(data.address) \(data.city) \(data.state) \(data.zipcode)"
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(cafeAddress, completionHandler: { (cafeLocation, error) in
                    if let location = cafeLocation?.first?.location?.coordinate {
                        let annotation = CafeAnnotation(coordinate: location, uid: data.uid, name: data.name, address: data.address, city: data.city, state: data.state, zipcode: data.zipcode, phoneNumber: data.phone)
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
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "coffee")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation { return }
        
        guard let cafeAnnotation = view.annotation as? CafeAnnotation else { return }

        let phoneFormatter = TextFormatter(textPattern: "(###) ###-####")
        let formatedNumber = phoneFormatter.formattedText(from: cafeAnnotation.phoneNumber)
        
        cafeCalloutName.text = cafeAnnotation.name
        cafeCalloutAddress.text = cafeAnnotation.address
        cafeCalloutCityStateZip.text = "\(cafeAnnotation.city), \(cafeAnnotation.state) \(cafeAnnotation.zipcode)"
        cafeCalloutPhone.text = formatedNumber
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
}
