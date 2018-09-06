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
    let spinner = Spinner()
    var userRole = "user"
    
    @IBAction func switchButton(_ sender: UISwitch) {
        userRole = sender.isOn ? "user": "cafe"
    }
    
    @IBAction func pressedSignUpButton(_ sender: Any) {
        spinner.startSpinner(view: view)
        guard let name = userName.text, let email = userEmail.text, let password = userPassword.text else { return }
        AuthService.instance.registerUser(name: name, email: email, password: password, userRole: userRole) { (success, error) in
            if success {
                AuthService.instance.loginUser(email: email, password: password, loginComplete: { (success, error) in
                    self.spinner.stopSpinner()
                    if success && self.userRole == "cafe" {
                        self.performSegue(withIdentifier: "toCafeProfileVC", sender: nil)
                    } else if success && self.userRole == "user" {
                        self.performSegue(withIdentifier: "toMapVC", sender: nil)
                    } else {
                       self.showAlert(withError: error)
                    }
                })
            } else {
                self.spinner.stopSpinner()
                self.showAlert(withError: error)
            }
        }
    }
    
    @IBAction func sendUserToLogin(_ sender: Any) {
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "LogInVC") else { return }
        present(loginVC, animated: true, completion: nil)
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
