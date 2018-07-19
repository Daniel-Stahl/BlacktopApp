//
//  CoffeeBeanCell.swift
//  Blacktop
//
//  Created by Daniel Stahl on 7/17/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class CoffeeBeanCell: UITableViewCell {

    @IBOutlet weak var beanName: UILabel!
    @IBOutlet weak var roasterName: UILabel!
    
    func configureCell(name: String, roaster: String) {
        self.beanName.text = name
        self.roasterName.text = roaster
    }
}
