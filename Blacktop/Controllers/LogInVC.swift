//
//  LogInVC.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/16/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {

    @IBOutlet weak var userEmail: CustomTextField!
    @IBOutlet weak var userPassword: CustomTextField!
    
    let toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userEmail.inputAccessoryView = toolBar
        userPassword.inputAccessoryView = toolBar
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.sizeToFit()
        
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    @IBAction func pressedLogInButton(_ sender: Any) {
        if userEmail.text != nil && userPassword.text != nil {
            AuthService.instance.loginUser(email: userEmail.text!, password: userPassword.text!) { (success, error) in
                if success {
                    let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC")
                    self.present(mapVC!, animated: true, completion: nil)
                } else {
                    print(String(describing: error?.localizedDescription))
                }
            }
        }
    }
    
    @IBAction func sendUserToSignup(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVC")
        present(loginVC!, animated: true, completion: nil)
    }
    
}
