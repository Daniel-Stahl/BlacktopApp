//
//  TimePicker.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/21/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class TimePicker: UITextField, UITextFieldDelegate {
    
    let toolBar = UIToolbar()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldDidBeginEditing(self)
        self.inputAccessoryView = toolBar
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))

        toolBar.setItems([doneButton], animated: false)
        toolBar.sizeToFit()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let timePickerView: UIDatePicker = UIDatePicker()
        
        timePickerView.datePickerMode = UIDatePickerMode.time
        
        self.inputView = timePickerView
        
        timePickerView.addTarget(self, action: #selector(timePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    @objc func timePickerValueChanged(sender: UIDatePicker) {
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.timeStyle = .short
        
        self.text = timeFormatter.string(from: sender.date)
        
    }

    @objc func doneClicked() {
            self.endEditing(true)
    }
    

}
