//
//  ProfileVC.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/18/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    @IBOutlet weak var userName: CustomTextField!
    @IBOutlet weak var userEmail: CustomTextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var currentUser = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        showUserProfile()
        tableView.delegate = self
        userName.isEnabled = false
        userEmail.isEnabled = false
    }
    
    func showUserProfile() {
        ref.child("users").child(currentUser!).observe(.value) { (Snapshot) in
            let data = Snapshot.value as? NSDictionary
            guard let name = data?["name"] as? String,
                let email = data?["email"] as? String else { return }
            
            self.userName.text = name
            self.userEmail.text = email
        }
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        userName.isEnabled = true
        userEmail.isEnabled = true
        editButton.isHidden = true
        saveButton.isHidden = false
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        updateUserProfile()
        saveButton.isHidden = true
        editButton.isHidden = false
        userName.isEnabled = false
        userEmail.isEnabled = false
    }
    
    func updateUserProfile() {
        if Auth.auth().currentUser?.email != userEmail.text {
            Auth.auth().currentUser?.updateEmail(to: userEmail.text!, completion: { (error) in
                if error != nil {
                    let userDetails = ["name": self.userName.text!, "email": self.userEmail.text!] as [String : Any]
                    
                    self.ref.child("users").child(self.currentUser!).updateChildValues(userDetails)
                }
            })
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC")
        self.present(mapVC!, animated: true, completion: nil)
    }
    
    @IBAction func pressedExitButton(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            
            do {
                try Auth.auth().signOut()
                let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as? WelcomeVC
                self.present(welcomeVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        logoutPopup.addAction(logoutCancel)
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserFavoriteCell", for: indexPath) as? UserFavoriteCell else { return UITableViewCell() }
        return cell
    }
}
