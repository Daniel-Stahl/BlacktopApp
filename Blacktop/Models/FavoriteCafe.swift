//
//  FavoriteCafe.swift
//  Blacktop
//
//  Created by Daniel Stahl on 8/8/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class FavoriteCafe {
    var cafeImageURL: String
    var cafeName: String
    var cafeAddress: String
    var cafeCityStateZip: String
    var key: String
    
    init(cafeImageURL: String, cafeName: String, cafeAddress: String, cafeCityStateZip: String, key: String) {
        self.cafeImageURL = cafeImageURL
        self.cafeName = cafeName
        self.cafeAddress = cafeAddress
        self.cafeCityStateZip = cafeCityStateZip
        self.key = key
    }
}
