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
        
//        showcafeInfo()
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
        name.isEnabled = true
    }
    
    func showcafeInfo() {
        DataService.instance.REF_USERS.child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (Snapshot) in
            let data = Snapshot.value as! [String: Any]
            if let cafeName = data["name"] as? String {
                self.name.text = cafeName
            }
            if let cafeAddress = data["address"] as? String {
                self.address.text = cafeAddress
            }
            if let cafeCity = data["city"] as? String {
                self.city.text = cafeCity
            }
            if let cafeState = data["state"] as? String {
                self.state.text = cafeState
            }
            if let cafeZipcode = data["zipcode"] as? Int {
                self.zipcode.text = String (cafeZipcode)
            }
            if let cafePhone = data["phone"] as? Int {
                self.phone.text = String (cafePhone)
            }
            if let cafeWebsite = data["website"] as? String {
                self.website.text = cafeWebsite
            }
        }
    }
    
    @IBAction func pressedSaveButton(_ sender: Any) {
//        DataService.instance.saveCafeInfo(name: name.text!, address: address.text!, city: city.text!, state: state.text!, zipcode: Int(zipcode.text!)!, phone: Int(phone.text!)!, website: website.text!) { (success, error) in
//            if success {
//
//            }
//        }
        
        let saveCafeInfo = Cafe(name: name.text!, address: address.text!, city: city.text!, state: state.text!, zipcode: Int(zipcode.text!)!, phone: Int(phone.text!)!, website: website.text!)
        saveCafeInfo.save()
        
        self.changeImageButton.isHidden = true
        self.editCafeProfileButton.isHidden = false
        self.saveCafeProfileButton.isHidden = true
        self.showAlert()
        name.isEnabled = false
    }
    
    func showAlert() {
    let alert = UIAlertController(title: "Success!", message: "Your information was saved successfully!", preferredStyle: .alert)
    self.present(alert, animated: true, completion: nil)
    Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    
    @IBAction func pressedChangeImageButton(_ sender: Any) {
    }
    
    
    
}








