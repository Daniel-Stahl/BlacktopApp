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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoriteCafeImage: UIImageView!
    
    var ref: DatabaseReference!
    var currentUser = Auth.auth().currentUser?.uid
    
    var favoriteCafe = [FavoriteCafe]()
    
    var passedCafeID: String = ""
    
    func initData(uid: String) {
        self.passedCafeID = uid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseService.instance.getFavoriteCafes(currentUser: currentUser!) { (returnedFavoriteCafe) in
            self.favoriteCafe = returnedFavoriteCafe
            self.tableView.reloadData()
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
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favorite"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCafe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserFavoriteCell", for: indexPath) as? UserFavoriteCell else { return UITableViewCell() }
        let data = favoriteCafe[indexPath.row]
        let url = URL(string: data.cafeImageURL)
        let imageData = try? Data(contentsOf: url!)
        cell.cafeImage.image = UIImage(data: imageData!)
        cell.configureCell(name: data.cafeName, address: data.cafeAddress, cityStateZip: data.cafeCityStateZip)
        
        return cell
    }
}
