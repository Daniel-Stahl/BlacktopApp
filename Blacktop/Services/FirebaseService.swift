//
//  DataServices.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/16/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import Foundation
import Firebase

var ref: DatabaseReference!

class FirebaseService {
    static let instance = FirebaseService()
    
    func createUser(uid: String, userData: Dictionary<String, Any>) {
        ref = Database.database().reference()
        ref.child("users").child(uid).updateChildValues(userData)
    }
    
    func getCoffeeBeans(passedUID: String, handler: @escaping (_ coffeebeans: [CoffeeBean]) -> ()) {
        ref = Database.database().reference()
        var beansArray = [CoffeeBean]()
        ref.child("users").child(passedUID).child("beans").observe(.value) { (beanSnapshot) in
            beansArray.removeAll()
            guard let data = beanSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for bean in data {
                let beanName = bean.childSnapshot(forPath: "name").value as! String
                let roasterName = bean.childSnapshot(forPath: "roaster").value as! String
                let beanKey = bean.key
                let coffeeBean = CoffeeBean(beanName: beanName, roasterName: roasterName, key: beanKey)
                beansArray.append(coffeeBean)
            }
            handler(beansArray)
        }
    }
}
