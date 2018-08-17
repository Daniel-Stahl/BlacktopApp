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
    
    var spinner: UIActivityIndicatorView?
    var screenSize = UIScreen.main.bounds
    
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
        addSpinner()
        if userEmail.text != nil && userPassword.text != nil {
            AuthService.instance.registerUser(name: userName.text!, email: userEmail.text!, password: userPassword.text!, userRole: userRole) { (success, error) in
                if success {
                    AuthService.instance.loginUser(email: self.userEmail.text!, password: self.userPassword.text!, loginComplete: { (success, error) in
                        if success && self.userRole == "cafe" {
                            self.stopSpinner()
//                            let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC")
//                            self.present(mapVC!, animated: true, completion: nil)
                            self.performSegue(withIdentifier: "toCafeProfileVC", sender: nil)
                        } else if success && self.userRole == "user" {
                            self.stopSpinner()
                            self.performSegue(withIdentifier: "toMapVC", sender: nil)
                        } else {
                            self.stopSpinner()
                           self.showAlert(withError: error)
                        }
                    })
                } else {
                    self.stopSpinner()
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
    
    func addSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screenSize.width / 2) - ((spinner?.frame.width)! / 2), y: screenSize.height / 2)
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.2511912882, green: 0.2511980534, blue: 0.2511944175, alpha: 1)
        spinner?.startAnimating()
        view.addSubview(spinner!)
    }
    
    func stopSpinner() {
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
}
