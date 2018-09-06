//
//  FavoriteCafe.swift
//  Blacktop
//
//  Created by Daniel Stahl on 8/8/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class FavoriteCafe {
    let cafeImageURL: String
    let cafeName: String
    let cafeAddress: String
    let cafeCityStateZip: String
    let uid: String
    
    init(cafeImageURL: String, cafeName: String, cafeAddress: String, cafeCityStateZip: String, uid: String) {
        self.cafeImageURL = cafeImageURL
        self.cafeName = cafeName
        self.cafeAddress = cafeAddress
        self.cafeCityStateZip = cafeCityStateZip
        self.uid = uid
    }
}
