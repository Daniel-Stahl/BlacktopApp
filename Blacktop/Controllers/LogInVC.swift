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
    let spinner = Spinner()

    @IBOutlet weak var userEmail: CustomTextField!
    @IBOutlet weak var userPassword: CustomTextField!
    
    @IBAction func pressedLogInButton(_ sender: Any) {
        spinner.startSpinner(view: view)
        guard let email = userEmail.text, let password = userPassword.text else { return }
        AuthService.instance.loginUser(email: email, password: password) { (success, error) in
            self.spinner.stopSpinner()
            if success {
                self.performSegue(withIdentifier: "toMapVC", sender: nil)
            } else {
                self.showAlert(withError: error)
            }
        }
    }
    
    @IBAction func sendUserToSignup(_ sender: Any) {
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") else { return }
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
