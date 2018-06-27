//
//  Cafe.swift
//  Blacktop
//
//  Created by Daniel Stahl on 6/25/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import CoreLocation

class Cafe {
    var location: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
    var name: String
    var address: String
    var city: String
    var state: String
    var zipcode: String
    
    init(name: String, address: String, city: String, state: String, zipcode: String) {
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.zipcode = zipcode
    }
    
    convenience init? (dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
            let address = dictionary["location/address"] as? String,
            let city = dictionary["location/city"] as? String,
            let state = dictionary["location/state"] as? String,
            let zip = dictionary["location/zipcode"] as? String else { return nil }
        
        self.init(name: name, address: address, city: city, state: state, zipcode: zip)
        
        if address != "" && city != "" && state != "" && zipcode != "" {
            let cafeAddress = "\(address) \(city) \(state) \(zipcode)"
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(cafeAddress) { (cafeLocation, error) in
                self.location = (cafeLocation?.first?.location?.coordinate)!
            }
        }
        
    }
}
