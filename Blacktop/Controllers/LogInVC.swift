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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func pressedLogInButton(_ sender: Any) {
        if userEmail.text != nil && userPassword.text != nil {
            AuthService.instance.loginUser(email: userEmail.text!, password: userPassword.text!) { (success, error) in
                if success {
                    print("Log in user successful")
                } else {
                    print(String(describing: error?.localizedDescription))
                }
            }
        }
    }
}
