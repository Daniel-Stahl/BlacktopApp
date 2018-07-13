//
//  CafeAnnotation.swift
//  Blacktop
//
//  Created by Daniel Stahl on 6/25/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import MapKit

class CafeAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var uid: String
    var name: String
    var address: String
    var city: String
    var state: String
    var zipcode: String
    var phoneNumber: String
    
    init(coordinate: CLLocationCoordinate2D, uid: String, name: String, address: String, city: String, state: String, zipcode: String, phoneNumber: String) {
        self.coordinate = coordinate
        self.uid = uid
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.phoneNumber = phoneNumber
    }
    
}
