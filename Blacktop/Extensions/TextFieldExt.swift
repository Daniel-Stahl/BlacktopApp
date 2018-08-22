//
//  TextFieldExt.swift
//  Blacktop
//
//  Created by Daniel Stahl on 8/22/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

extension CafeProfileVC {
    func disableTextField() {
        name.isEnabled = false
        address.isEnabled = false
        city.isEnabled = false
        state.isEnabled = false
        zipcode.isEnabled = false
        phone.isEnabled = false
        website.isEnabled = false
        monOpen.isEnabled = false
        monClose.isEnabled = false
        tueOpen.isEnabled = false
        tueClose.isEnabled = false
        wedOpen.isEnabled = false
        wedClose.isEnabled = false
        thuOpen.isEnabled = false
        thuClose.isEnabled = false
        friOpen.isEnabled = false
        friClose.isEnabled = false
        satOpen.isEnabled = false
        satClose.isEnabled = false
        sunOpen.isEnabled = false
        sunClose.isEnabled = false
    }
    
    func enableTextField() {
        name.isEnabled = true
        address.isEnabled = true
        city.isEnabled = true
        state.isEnabled = true
        zipcode.isEnabled = true
        phone.isEnabled = true
        website.isEnabled = true
        monOpen.isEnabled = true
        monClose.isEnabled = true
        tueOpen.isEnabled = true
        tueClose.isEnabled = true
        wedOpen.isEnabled = true
        wedClose.isEnabled = true
        thuOpen.isEnabled = true
        thuClose.isEnabled = true
        friOpen.isEnabled = true
        friClose.isEnabled = true
        satOpen.isEnabled = true
        satClose.isEnabled = true
        sunOpen.isEnabled = true
        sunClose.isEnabled = true
    }
}
