//
//  CustomButton.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/16/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = #colorLiteral(red: 0.2511912882, green: 0.2511980534, blue: 0.2511944175, alpha: 1)
        layer.borderWidth = 1
        layer.cornerRadius = 16
    }

}
