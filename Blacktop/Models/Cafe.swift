//
//  Cafe.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/21/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase

class Cafe {
//    private var image: UIImage!
    let name: String
//    var imageDownloadURL: String?
    let address: String
    let city: String
    let state: String
    let zipcode: Int
    let phone: Int
    let website: String
    
    init(name: String, address: String, city: String, state: String, zipcode: Int, phone: Int, website: String) {
//        self.image = image
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.phone = phone
        self.website = website

    }
    
    func save() {
        let cafeUID = Auth.auth().currentUser?.uid
        
//        if let imageData = UIImageJPEGRepresentation(self.image, 0.6) {
//            let imageRef = DataService.instance.REF_STORAGE.child(cafeUID!)
//
//            imageRef.putData(imageData).observe(.success, handler: { (imageSnapshot) in
//                self.imageDownloadURL = (imageSnapshot.metadata?.downloadURL()?.absoluteString)!
        
                let cafeDictionary = [
//                    "imageDownloadURL" : self.imageDownloadURL,
                    "name" : self.name,
                    "address" : self.address,
                    "city" : self.city,
                    "state" : self.state,
                    "zipcode" : self.zipcode,
                    "phone" : self.phone,
                    "website" : self.website,
                    ] as [String : Any]
        DataService.instance.REF_USERS.child(cafeUID!).updateChildValues(cafeDictionary)
//            })
//        }
    }
}
