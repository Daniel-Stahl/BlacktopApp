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
        
        showcafeInfo()
    }
    

    @IBAction func pressedLogoutButton(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
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
        logoutPopup.addAction(logoutCancel)
        present(logoutPopup, animated: true, completion: nil)
    }
    
    @IBAction func pressedEditButton(_ sender: Any) {
        changeImageButton.isHidden = false
        editCafeProfileButton.isHidden = true
        saveCafeProfileButton.isHidden = false
        name.isEnabled = true
        address.isEnabled = true
        city.isEnabled = true
        state.isEnabled = true
        zipcode.isEnabled = true
        phone.isEnabled = true
        website.isEnabled = true
    }
    
    func showcafeInfo() {
        FirebaseService.instance.refUsers.child((Auth.auth().currentUser?.uid)!).observe(.value) { (Datasnapshot) in
            let data = Datasnapshot.value as? NSDictionary
            guard let cafeName = data!["name"] as? String else { return }
            guard let cafeAddress = data!["location"] as? String else { return }
//            guard let cafeCity = data["city"] as? String else { return }
//            guard let cafeState = data["state"] as? String else { return }
//            guard let cafeZipcode = data["zipcode"] as? Int else { return }
//            guard let cafePhone = data["phone"] as? Int else { return }
//            guard let cafeWebsite = data["website"] as? String else { return }
            
            self.name.text = cafeName
            print(cafeAddress)
//            self.address.text = cafeAddress
//            self.city.text = cafeCity
//            self.state.text = cafeState
//            self.zipcode.text = String(cafeZipcode)
//            self.phone.text = String(cafePhone)
//            self.website.text = cafeWebsite
        }
    }
    
    @IBAction func pressedSaveButton(_ sender: Any) {
//        guard let cafeName = name.text else { return }
//        guard let cafeAddress = address.text else { return }
//        guard let cafeCity = city.text else { return }
//        guard let cafeState = state.text else { return }
//        guard let cafeZipcode = zipcode.text else { return }
//        guard let cafePhone = phone.text else { return }
//        guard let cafeWebsite = website.text else { return }
        guard let monFrom = monFrom.text else { return }
        guard let monTo = monTo.text else { return }
        guard let tueFrom = tueFrom.text else { return }
        guard let tueTo = tueTo.text else { return }
        guard let wedFrom = wedFrom.text else { return }
        guard let wedTo = wedTo.text else { return }
        guard let thuFrom = thuFrom.text else { return }
        guard let thuTo = thuTo.text else { return }
        guard let friFrom = friFrom.text else { return }
        guard let friTo = friTo.text else { return }
        guard let satFrom = satFrom.text else { return }
        guard let satTo = satTo.text else { return }
        guard let sunFrom = sunFrom.text else { return }
        guard let sunTo = sunTo.text else { return }
        
        let cafeDetails = ["name": name.text!, "location": ["address": address.text!, "city": city.text!, "state": state.text!, "zipcode": zipcode.text!], "phone": phone.text!, "website": website.text!, "monFrom": monFrom, "monTo": monTo, "tueFrom": tueFrom] as [String : Any]
        FirebaseService.instance.saveCafeInfo(cafeData: cafeDetails)
        
        self.changeImageButton.isHidden = true
        self.editCafeProfileButton.isHidden = false
        self.saveCafeProfileButton.isHidden = true
        name.isEnabled = false
        address.isEnabled = false
        city.isEnabled = false
        state.isEnabled = false
        zipcode.isEnabled = false
        phone.isEnabled = false
        website.isEnabled = false
    }

    
    
    @IBAction func pressedChangeImageButton(_ sender: Any) {
    }
    
    
    
}








