//
//  AuthService.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/16/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func registerUser(name: String, email: String, password: String, userRole: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user?.user else {
                userCreationComplete(false, error)
                return
            }
            
            if userRole == "cafe" {
                let userData = ["provider": user.providerID , "name": name, "email": user.email, "role": userRole, "photoURL": "", "location": ["address": "", "city": "", "state": "", "zipcode": ""], "phone": "", "website": "", "hours": ["monOpen": "", "monClose": "", "tueOpen": "", "tueClose": "", "wedOpen": "", "wedClose": "", "thuOpen": "", "thuClose": "", "friOpen": "", "friClose": "", "satOpen": "", "satClose": "", "sunOpen": "", "sunClose": ""]] as [String : Any]
                DatabaseService.instance.createUser(uid: user.uid, userData: userData as Dictionary<String, Any>)
            } else {
                let userData = ["provider": user.providerID , "name": name, "email": user.email, "role": userRole]
                DatabaseService.instance.createUser(uid: user.uid, userData: userData as Dictionary<String, Any>)
            }
            
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(email: String, password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            } else {
                loginComplete(true, nil)
            }
        }
    }
    
}
