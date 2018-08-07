//
//  LogInVC.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/16/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase

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
                    let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC")
                    self.present(mapVC!, animated: true, completion: nil)
                } else {
                    self.showAlert(withError: error)
                    print(String(describing: error?.localizedDescription))
                }
            }
        }
    }
    
    @IBAction func sendUserToSignup(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVC")
        present(loginVC!, animated: true, completion: nil)
    }
    
    func showAlert(withError error: Error!) {
        let errorCode = AuthErrorCode(rawValue: error._code)
        let errorAlert = UIAlertController(title: "Error!", message: errorCode?.errorMessage, preferredStyle: .alert)
        present(errorAlert, animated: true) {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
}
