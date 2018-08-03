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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        if success {
                            let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC")
                            self.present(mapVC!, animated: true, completion: nil)
                        } else {
                            print(error!)
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
