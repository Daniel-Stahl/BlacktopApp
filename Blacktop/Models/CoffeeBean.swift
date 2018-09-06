//
//  CoffeeBean.swift
//  Blacktop
//
//  Created by Daniel Stahl on 7/18/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class CoffeeBean {
    let beanName: String
    let roasterName: String
    let key: String
    
    init(beanName: String, roasterName: String, key: String) {
        self.beanName = beanName
        self.roasterName = roasterName
        self.key = key
    }
}
