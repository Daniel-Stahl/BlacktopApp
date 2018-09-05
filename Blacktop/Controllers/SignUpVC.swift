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
        spinner.startSpinner(view: view)
        if userEmail.text != nil && userPassword.text != nil {
            AuthService.instance.registerUser(name: userName.text!, email: userEmail.text!, password: userPassword.text!, userRole: userRole) { (success, error) in
                if success {
                    AuthService.instance.loginUser(email: self.userEmail.text!, password: self.userPassword.text!, loginComplete: { (success, error) in
                        if success && self.userRole == "cafe" {
                            self.spinner.stopSpinner()
                            self.performSegue(withIdentifier: "toCafeProfileVC", sender: nil)
                        } else if success && self.userRole == "user" {
                            self.spinner.stopSpinner()
                            self.performSegue(withIdentifier: "toMapVC", sender: nil)
                        } else {
                            self.spinner.stopSpinner()
                           self.showAlert(withError: error)
                        }
                    })
                } else {
                    self.spinner.stopSpinner()
                    self.showAlert(withError: error)
                }
            }
        }
    }
    
    @IBAction func sendUserToLogin(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LogInVC")
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
