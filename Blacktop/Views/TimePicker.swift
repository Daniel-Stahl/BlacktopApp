//
//  TimePicker.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/21/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class TimePicker: UITextField, UITextFieldDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldDidBeginEditing(self)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let timePickerView = UIDatePicker()
        timePickerView.datePickerMode = UIDatePicker.Mode.time
        self.inputView = timePickerView
        timePickerView.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
    }
    
    @objc func timePickerValueChanged(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        self.text = timeFormatter.string(from: sender.date)
        
    }
}
