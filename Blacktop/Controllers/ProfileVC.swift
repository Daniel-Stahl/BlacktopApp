//
//  ProfileVC.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/18/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var childVC: UIView!
//    let main = DispatchQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
            DataService.instance.REF_USERS.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (Snapshot) in
                let data = Snapshot.value as! [String: Any]
                let userRole = data["role"] as! String
                
                if userRole == "cafe" {
                    self.childVC.isHidden = false
                } else {
                    self.childVC.isHidden = true
                }
            }
    }
    
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        DataService.instance.REF_USERS.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (Snapshot) in
//            let data = Snapshot.value as! [String: Any]
//            let userRole = data["role"] as! String
//
//            if userRole == "cafe" {
//                self.childVC.isHidden = false
//            } else {
//                self.childVC.isHidden = true
//            }
//        }
//    }

    @IBAction func pressedExitButton(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            
            do {
                try Auth.auth().signOut()
                let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as? WelcomeVC
                self.present(welcomeVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
}
