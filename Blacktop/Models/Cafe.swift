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
    var monOpen: String
    var monClose: String
    var tueOpen: String
    var tueClose: String
    var wedOpen: String
    var wedClose: String
    var thuOpen: String
    var thuClose: String
    var friOpen: String
    var friClose: String
    var satOpen: String
    var satClose: String
    var sunOpen: String
    var sunClose: String
    
    init(key: String,
        name: String,
        address: String,
        city: String,
        state: String,
        zipcode: String,
        phone: String,
        website: String,
        monOpen: String,
        monClose: String,
        tueOpen: String,
        tueClose: String,
        wedOpen: String,
        wedClose: String,
        thuOpen: String,
        thuClose: String,
        friOpen: String,
        friClose: String,
        satOpen: String,
        satClose: String,
        sunOpen: String,
        sunClose: String) {
        
        self.key = key
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.phone = phone
        self.website = website
        self.monOpen = monOpen
        self.monClose = monClose
        self.tueOpen = tueOpen
        self.tueClose = tueClose
        self.wedOpen = wedOpen
        self.wedClose = wedClose
        self.thuOpen = thuOpen
        self.thuClose = thuClose
        self.friOpen = friOpen
        self.friClose = friClose
        self.satOpen = satOpen
        self.satClose = satClose
        self.sunOpen = sunOpen
        self.sunClose = sunClose
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
        let website = dictionary["website"] as? String,
            
        let hours = dictionary["hours"] as? [String: Any],
        let monOpen = hours["monOpen"] as? String,
        let monClose = hours["monClose"] as? String,
        let tueOpen = hours["tueOpen"] as? String,
        let tueClose = hours["tueClose"] as? String,
        let wedOpen = hours["wedOpen"] as? String,
        let wedClose = hours["wedClose"] as? String,
        let thuOpen = hours["thuOpen"] as? String,
        let thuClose = hours["thuClose"] as? String,
        let friOpen = hours["friOpen"] as? String,
        let friClose = hours["friClose"] as? String,
        let satOpen = hours["satOpen"] as? String,
        let satClose = hours["satClose"] as? String,
        let sunOpen = hours["sunOpen"] as? String,
        let sunClose = hours["sunClose"] as? String else { return nil }
        
        self.init(key: key,
                  name: name,
                  address: address,
                  city: city,
                  state: state,
                  zipcode: zipcode,
                  phone: phone,
                  website: website,
                  monOpen: monOpen,
                  monClose: monClose,
                  tueOpen: tueOpen,
                  tueClose: tueClose,
                  wedOpen: wedOpen,
                  wedClose: wedClose,
                  thuOpen: thuOpen,
                  thuClose: thuClose,
                  friOpen: friOpen,
                  friClose: friClose,
                  satOpen: satOpen,
                  satClose: satClose,
                  sunOpen: sunOpen,
                  sunClose: sunClose)
    }
}
