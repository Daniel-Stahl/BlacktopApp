//
//  ViewController.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/16/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func pressedLogInButton(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LogInVC")
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func pressedSignUpButton(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVC")
        present(loginVC!, animated: true, completion: nil)
    }
    
}

