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
    
    //Refactor code
}
