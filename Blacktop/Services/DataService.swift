//
//  DataServices.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/16/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
let DB_STORAGE = Storage.storage().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_STORAGE = DB_STORAGE.child("photos")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_STORAGE: StorageReference {
        return _REF_STORAGE
    }
    
    func createUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func saveCafeInfo(name: String, address: String, city: String, state: String, zipcode: Int, phone: Int, website: String, completionHandler: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        REF_USERS.child((Auth.auth().currentUser?.uid)!).updateChildValues(["name": name, "address": address, "city": city, "state": state, "zipcode": zipcode, "phone": phone, "website": website])
    }
    
    func saveCafeHours(monFrom: String, monTo: String, tueFrom: String, tueTo: String) {
        REF_USERS.child((Auth.auth().currentUser?.uid)!).child("hours").updateChildValues(["mondayFrom": monFrom, "mondayTo": monTo, "tuesdayFrom": tueFrom, "tuesdayTo": tueTo])
    }
}
