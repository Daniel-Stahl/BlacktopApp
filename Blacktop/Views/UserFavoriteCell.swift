//
//  UserFavoriteCell.swift
//  Blacktop
//
//  Created by Daniel Stahl on 8/7/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class UserFavoriteCell: UITableViewCell {

    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var cafeImage: UIImageView!
    @IBOutlet weak var cafeName: UILabel!
    @IBOutlet weak var cafeAddress: UILabel!
    @IBOutlet weak var cafeCityStateZip: UILabel!
    
    func configureCell(name: String, address: String, cityStateZip: String) {
        self.cafeName.text = name
        self.cafeAddress.text = address
        self.cafeCityStateZip.text = cityStateZip
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        overlay.layer.cornerRadius = 16
        cafeImage.layer.cornerRadius = 16
    }
}
