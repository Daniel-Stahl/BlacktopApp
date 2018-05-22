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
    private var image: UIImage!
    let name: String
    var imageDownloadURL: String?
    let address: String
    let city: String
    let state: String
    let zipcode: Int
    let phone: Int
    let monday: Int
    let hours: String
    let website: String
    let facebook: String
    let twitter: String
    let instagram: String
    
    init(image: UIImage, name: String, address: String, city: String, state: String, zipcode: Int, phone: Int, monday: Int, hours: String, website: String, facebook: String, twitter: String, instagram: String) {
        self.image = image
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.phone = phone
        self.monday = monday
        self.hours = hours
        self.website = website
        self.facebook = facebook
        self.twitter = twitter
        self.instagram = instagram
    }
    
    func save() {
        let cafeUID = Auth.auth().currentUser?.uid
        
        if let imageData = UIImageJPEGRepresentation(self.image, 0.6) {
            let imageRef = DataService.instance.REF_STORAGE.child(cafeUID!)
            
            imageRef.putData(imageData).observe(.success, handler: { (imageSnapshot) in
                self.imageDownloadURL = (imageSnapshot.metadata?.downloadURL()?.absoluteString)!
                
                let cafeDictionary = [
                    "imageDownloadURL" : self.imageDownloadURL,
                    "name" : self.name,
                    "address" : self.address,
                    "hours" : self.hours,
                    "website" : self.website,
                    "facebook" : self.facebook,
                    "twitter" : self.twitter,
                    "instagram" : self.instagram
                    
                ]
                DataService.instance.REF_USERS.child((Auth.auth().currentUser?.uid)!).updateChildValues(cafeDictionary)
            })
        }
    }
}
