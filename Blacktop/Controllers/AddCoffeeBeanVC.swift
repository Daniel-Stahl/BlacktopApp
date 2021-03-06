//
//  AddCoffeeBeanVC.swift
//  Blacktop
//
//  Created by Daniel Stahl on 7/18/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase

class AddCoffeeBeanVC: UIViewController {
    var ref: DatabaseReference!
    let currentUser = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var beanName: CustomTextField!
    @IBOutlet weak var roasterName: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if beanName.text == "" && roasterName.text == "" {
            print("no beans")
        } else {
            guard let name = beanName.text, let roaster = roasterName.text else { return }
            let addBeanDetails = ["name": name, "roaster": roaster] as [String : Any]
            ref.child("users").child(currentUser!).child("beans").childByAutoId().updateChildValues(addBeanDetails)
            beanName.text = ""
            roasterName.text = ""
        }
    }
}
