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
    
    func getCoffeeBeans(passedUID: String, handler: @escaping (_ coffeebeans: [CoffeeBean]) -> ()) {
        var beansArray = [CoffeeBean]()
        refUsers.child(passedUID).child("beans").observe(.value) { (beanSnapshot) in
            beansArray.removeAll()
            guard let data = beanSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for bean in data {
                let beanName = bean.childSnapshot(forPath: "name").value as! String
                let roasterName = bean.childSnapshot(forPath: "roaster").value as! String
                let coffeeBean = CoffeeBean(beanName: beanName, roasterName: roasterName)
                beansArray.append(coffeeBean)
            }
            handler(beansArray)
        }
    }
    
//    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()) {
//        var messageArray = [Message]()
//        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
//            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
//            for message in feedMessageSnapshot {
//                let content = message.childSnapshot(forPath: "content").value as! String
//                let senderId = message.childSnapshot(forPath: "senderId").value as! String
//                let message = Message(content: content, senderId: senderId)
//                messageArray.append(message)
//            }
//            handler(messageArray)
//        }
//    }
    
    //Refactor code
}
