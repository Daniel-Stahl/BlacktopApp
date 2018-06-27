//
//  DataServices.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/16/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import Foundation
import Firebase

let ref = Database.database().reference()

class FirebaseService {
    static let instance = FirebaseService()
    
    let refUsers = ref.child("users")
    
    func createUser(uid: String, userData: Dictionary<String, Any>) {
        refUsers.child(uid).updateChildValues(userData)
    }
    
    func getCafeData() {
        
        ref.child("users").observe(.value) { (Datasnapshot) in
            guard let data = Datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            for cafeData in data {
                guard let address = cafeData.childSnapshot(forPath: "location/address").value as? String else { continue }
                guard let city = cafeData.childSnapshot(forPath: "location/city").value as? String else { continue }
                guard let state = cafeData.childSnapshot(forPath: "location/state").value as? String else { continue }
                guard let zipcode = cafeData.childSnapshot(forPath: "location/zipcode").value as? String else { continue }
                guard let name = cafeData.childSnapshot(forPath: "name").value as? String else { continue }
                
                
                
                
//                if address != "" && city != "" && state != "" && zipcode != "" {
//                    let cafeAddress = "\(address) \(city) \(state) \(zipcode)"
//                    let geoCoder = CLGeocoder()
//                    geoCoder.geocodeAddressString(cafeAddress, completionHandler: { (cafeLocation, error) in
//                        let location = cafeLocation?.first?.location?.coordinate
//                        let cafeList = Cafe(name: name)
//                        cafeList.location = location!
//                        self.cafe.append(cafeList)
//                    })
//                }
            }
        }
    }
    
    //Refactor code
}
