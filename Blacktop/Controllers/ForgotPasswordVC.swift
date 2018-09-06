//
//  ForgotPasswordVC.swift
//  Blacktop
//
//  Created by Daniel Stahl on 8/7/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {
    @IBOutlet weak var userEmail: CustomTextField!
    
    @IBAction func pressedSubmitButton(_ sender: Any) {
        sendPasswordReset(withEmail: userEmail.text!) { (error) in
            self.alertUser(withError: error)
        }
    }
    
    @IBAction func pressedCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func sendPasswordReset(withEmail email: String, errorHandle: @escaping (_ error: Error?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            errorHandle(error)
        }
    }
    
    func alertUser(withError error: Error!) {
        if error != nil {
            print(error)
            let errorCode = AuthErrorCode(rawValue: error._code)
            let errorAlert = UIAlertController(title: "Error!", message: errorCode?.errorMessage, preferredStyle: .alert)
            present(errorAlert, animated: true) {
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (_) in
                    self.dismiss(animated: true, completion: nil)
                })
            }
        } else {
        let successAlert = UIAlertController(title: "Success!", message: "Please check your email for further instructions", preferredStyle: .alert)
            present(successAlert, animated: true) {
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (_) in
                    self.dismiss(animated: true, completion: nil)
                    self.userEmail.text = ""
                })
            }
        }
    }
}
