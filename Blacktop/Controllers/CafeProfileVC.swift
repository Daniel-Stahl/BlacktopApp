//
//  CafeProfile.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/21/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase

class CafeProfileVC: UIViewController {

    @IBOutlet weak var editCafeProfileButton: UIButton!
    @IBOutlet weak var saveCafeProfileButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var website: UITextField!
    
    @IBOutlet weak var monFrom: TimePicker!
    @IBOutlet weak var monTo: TimePicker!
    @IBOutlet weak var tueFrom: TimePicker!
    @IBOutlet weak var tueTo: TimePicker!
    @IBOutlet weak var wedFrom: TimePicker!
    @IBOutlet weak var wedTo: TimePicker!
    @IBOutlet weak var thuFrom: TimePicker!
    @IBOutlet weak var thuTo: TimePicker!
    @IBOutlet weak var friFrom: TimePicker!
    @IBOutlet weak var friTo: TimePicker!
    @IBOutlet weak var satFrom: TimePicker!
    @IBOutlet weak var satTo: TimePicker!
    @IBOutlet weak var sunFrom: TimePicker!
    @IBOutlet weak var sunTo: TimePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func pressedLogoutButton(_ sender: Any) {
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
    
    @IBAction func pressedEditButton(_ sender: Any) {
        changeImageButton.isHidden = false
        editCafeProfileButton.isHidden = true
        saveCafeProfileButton.isHidden = false
        
    }
    
    @IBAction func pressedSaveButton(_ sender: Any) {
        DataService.instance.saveCafeInfo(name: name.text!, address: address.text!, city: city.text!, state: state.text!, zipcode: Int(zipcode.text!)!, phone: Int(phone.text!)!, website: website.text!) { (success, error) in
            if success {
                self.changeImageButton.isHidden = true
                self.editCafeProfileButton.isHidden = false
                self.saveCafeProfileButton.isHidden = true
            } else {
            print(String(describing: error?.localizedDescription))
            }
        }
    }
    
    
    
    
    @IBAction func pressedChangeImageButton(_ sender: Any) {
    }
    
    
    
}








