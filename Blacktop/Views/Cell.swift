//
//  Cell.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/22/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var website: UITextField!
    
    @IBOutlet weak var monFrom: TimePicker!
    @IBOutlet weak var monTo: TimePicker!
    @IBOutlet weak var tueFrom: TimePicker!
    @IBOutlet weak var tueTo: TimePicker!
    @IBOutlet weak var wedFrom: TimePicker!
    @IBOutlet weak var wedTo: TimePicker!
    @IBOutlet weak var thuFrom: TimePicker!
    @IBOutlet weak var thuTo: TimePicker!
    @IBOutlet weak var friFrom: TimePicker!
    @IBOutlet weak var friTo: TimePicker!
    @IBOutlet weak var satFrom: TimePicker!
    @IBOutlet weak var satTo: TimePicker!
    @IBOutlet weak var sunFrom: TimePicker!
    @IBOutlet weak var sunTo: TimePicker!
    
    
    
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
