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
    var key: String
    var name: String
    var address: String
    var city: String
    var state: String
    var zipcode: String
    var phone: String
    var website: String
    
    init(key: String, name: String, address: String, city: String, state: String, zipcode: String, phone: String, website: String) {
        self.key = key
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.phone = phone
        self.website = website
    }
    
    convenience init? (dictionary: [String: Any], key: String) {
        let key = key
        guard let name = dictionary["name"] as? String,
        let location = dictionary["location"] as? [String: Any],
        let address = location["address"] as? String,
        let city = location["city"] as? String,
        let state = location["state"] as? String,
        let zipcode = location["zipcode"] as? String,
        let phone = dictionary["phone"] as? String,
        let website = dictionary["website"] as? String else { return nil }
        
        self.init(key: key, name: name, address: address, city: city, state: state, zipcode: zipcode, phone: phone, website: website)
        
    }
}
