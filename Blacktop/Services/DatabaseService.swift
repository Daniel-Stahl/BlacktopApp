//
//  DataServices.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/16/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import Foundation
import Firebase

//turn property


class DatabaseService {
    var ref: DatabaseReference!
    static let instance = DatabaseService()
    var currentUser = Auth.auth().currentUser?.uid
    
    func createUser(uid: String, userData: Dictionary<String, Any>) {
        ref = Database.database().reference()
        ref.child("users").child(uid).updateChildValues(userData)
    }
    
    func getCafeData(completion: @escaping (_ cafe: [Cafe]) -> ()) {
        ref = Database.database().reference()
        var cafeArray = [Cafe]()
        ref.child("users").observe(.value) { (dataSnap) in
            DispatchQueue.main.async {
                for userChild in dataSnap.children {
                    let childSnap = userChild as! DataSnapshot
                    guard let cafeData = childSnap.value as? [String: Any] else { return }
                    if let cafe = Cafe(dictionary: cafeData, uid: childSnap.key) {
                        cafeArray.append(cafe)
                    }
                    completion(cafeArray)
                }
            }
        }
    }
    
    func getCurrentUserCafeData(currentUser: String, completion: @escaping (_ cafe: Cafe) -> ()) {
        ref = Database.database().reference()
        ref.child("users").child(currentUser).observe(.value) { (dataSnap) in
            DispatchQueue.main.async {
                guard let cafeData = dataSnap.value as? [String: Any] else { return }
                let cafe = Cafe(dictionary: cafeData, uid: dataSnap.key)
                completion(cafe!)
            }
        }
    }
    
    func getCoffeeBeans(passedUID: String, handler: @escaping (_ coffeebeans: [CoffeeBean]) -> ()) {
        ref = Database.database().reference()
        var beansArray = [CoffeeBean]()
        ref.child("users").child(passedUID).child("beans").observe(.value) { (beanSnapshot) in
            DispatchQueue.main.async {
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
    
    func getFavoriteCafes(currentUser: String, handler: @escaping (_ favoritecafe: [FavoriteCafe]) -> ()) {
        ref = Database.database().reference()
        var favoriteCafeArray = [FavoriteCafe]()
        ref.child("users").child(currentUser).child("favorites").observe(.value) { (favoriteSnapshot) in
            DispatchQueue.main.async {
                favoriteCafeArray.removeAll()
                guard let data = favoriteSnapshot.children.allObjects as? [DataSnapshot] else { return }
                for favorite in data {
                    let cafeImageURL = favorite.childSnapshot(forPath: "imageURL").value as! String
                    let cafeName = favorite.childSnapshot(forPath: "name").value as! String
                    let cafeAddress = favorite.childSnapshot(forPath: "location/address").value as! String
                    let cafeCityStateZip = favorite.childSnapshot(forPath: "location/cityStateZip").value as! String
                    let favoriteKey = favorite.key
                    let favoriteCafe = FavoriteCafe(cafeImageURL: cafeImageURL, cafeName: cafeName, cafeAddress: cafeAddress, cafeCityStateZip: cafeCityStateZip, uid: favoriteKey)
                    favoriteCafeArray.append(favoriteCafe)
                }
                handler(favoriteCafeArray)
            }
        }
    }
}