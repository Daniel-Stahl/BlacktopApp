//
//  SignUpVC.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/16/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    @IBOutlet weak var userName: CustomTextField!
    @IBOutlet weak var userEmail: CustomTextField!
    @IBOutlet weak var userPassword: CustomTextField!
    
    var userRole = "user"
    
    let toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.inputAccessoryView = toolBar
        userEmail.inputAccessoryView = toolBar
        userPassword.inputAccessoryView = toolBar
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.sizeToFit()
        
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    @IBAction func switchButton(_ sender: UISwitch) {
        if (sender.isOn == false) {
            userRole = "user"
        } else {
            userRole = "cafe"
        }
    }
    
    @IBAction func pressedSignUpButton(_ sender: Any) {
        if userEmail.text != nil && userPassword.text != nil {
            AuthService.instance.registerUser(name: userName.text!, email: userEmail.text!, password: userPassword.text!, userRole: userRole) { (success, error) in
                if success {
                    
                    AuthService.instance.loginUser(email: self.userEmail.text!, password: self.userPassword.text!, loginComplete: { (success, error) in
                        if self.userRole == "cafe" {
                            let cafeProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "CafeProfileVC")
                            self.present(cafeProfileVC!, animated: true, completion: nil)
                        } else {
                            let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC")
                            self.present(mapVC!, animated: true, completion: nil)
                        }
                    })
                } else {
                    print(String(describing: error?.localizedDescription))
                }
            }
        }
    }
    
    @IBAction func sendUserToLogin(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LogInVC")
        present(loginVC!, animated: true, completion: nil)
    }
}
