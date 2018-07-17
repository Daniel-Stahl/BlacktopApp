//
//  CafeVC.swift
//  Blacktop
//
//  Created by Daniel Stahl on 7/9/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase

class CafeVC: UIViewController {
    var ref: DatabaseReference!
    let storage = Storage.storage().reference()
    let currentUser = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var cafeImage: UIImageView!
    @IBOutlet weak var cafeName: UILabel!
    @IBOutlet weak var cafeAddress: UILabel!
    @IBOutlet weak var cafeCityStateZip: UILabel!
    @IBOutlet weak var cafePhone: UILabel!
    @IBOutlet weak var cafeWebsite: UILabel!
    @IBOutlet weak var cafeHours: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
    var passedCafeID: String = ""
    
    func initData(uid: String) {
        self.passedCafeID = uid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        print(Date().dayOfWeek()!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadProfile()
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "CafeProfileVC")
        self.present(profileVC!, animated: true, completion: nil)
    }
    
    func loadProfile() {
        ref.child("users").child(passedCafeID).observeSingleEvent(of: .value) { (Snapshot) in
            let data = Snapshot.value as! [String: Any]
            let userRole = data["role"] as! String
            
            if userRole == "cafe" && self.passedCafeID == self.currentUser {
                self.editProfileButton.isHidden = false
            } else {
                self.editProfileButton.isHidden = true
            }
        }
        
        let imageRef = storage.child("photos").child(passedCafeID)
        let downloadTask = imageRef.getData(maxSize: 1024 * 1024) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                self.cafeImage.image = image
            }
            print(error ?? "No error")
        }
        
        ref.child("users").child(passedCafeID).observe(.value) { (Datasnapshot) in
            guard let data = Datasnapshot.value as? [String: Any] else { return }
            let name = data["name"] as? String
            let phone = data["phone"] as? String
            let website = data["website"] as? String
            
            self.cafeName.text = name
            self.cafePhone.text = phone
            self.cafeWebsite.text = website
        }
        
        ref.child("users").child(passedCafeID).child("location").observe(.value) { (Datasnapshot) in
            guard let data = Datasnapshot.value as? [String: Any] else { return }
            let address = data["address"] as? String
            let city = data["city"] as? String
            let state = data["state"] as? String
            let zipcode = data["zipcode"] as? String
            
            self.cafeAddress.text = address
            self.cafeCityStateZip.text = "\(city!), \(state!) \(zipcode!)"
        }
        
        
    }

}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        
    }
}
