//
//  KeyboardDoneButton.swift
//  Blacktop
//
//  Created by Daniel Stahl on 7/21/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

extension UIViewController: UITextFieldDelegate {
    
    func keyboardDoneButton(textfield: UITextField) {
        let toolBar = UIToolbar()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneButtonClicked))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.sizeToFit()
        
        textfield.delegate = self
        textfield.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonClicked() {
        view.endEditing(true)
    }
}
