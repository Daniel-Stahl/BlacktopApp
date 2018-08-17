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
    
    var spinner: UIActivityIndicatorView?
    var screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func pressedLogInButton(_ sender: Any) {
        addSpinner()
        if userEmail.text != nil && userPassword.text != nil {
            AuthService.instance.loginUser(email: userEmail.text!, password: userPassword.text!) { (success, error) in
                if success {
                    self.stopSpinner()
                    //let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC")
                    //self.present(mapVC!, animated: true, completion: nil)
                    self.performSegue(withIdentifier: "toMapVC", sender: nil)
                } else {
                    self.stopSpinner()
                    self.showAlert(withError: error)
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
