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
    @IBAction func unwindFromCafeVC(segue:UIStoryboardSegue) { }
    
    var ref: DatabaseReference!
    var currentUser = Auth.auth().currentUser?.uid
    
    var favoriteCafe = [FavoriteCafe]()
    
    var passedCafeID: String = ""
    
    func initData(uid: String) {
        self.passedCafeID = uid
    }
    
    var screenSize = UIScreen.main.bounds
    var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addSpinner()
        FirebaseService.instance.getFavoriteCafes(currentUser: currentUser!) { (returnedFavoriteCafe) in
            self.favoriteCafe = returnedFavoriteCafe
            self.tableView.reloadData()
            self.stopSpinner()
            
        }
    }
    
    func addSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screenSize.width / 2) - ((spinner?.frame.width)! / 2), y: screenSize.height / 2)
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.2511912882, green: 0.2511980534, blue: 0.2511944175, alpha: 1)
        spinner?.startAnimating()
        view.addSubview(spinner!)
    }

    func stopSpinner() {
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        return "Favorites"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = #colorLiteral(red: 0.2511912882, green: 0.2511980534, blue: 0.2511944175, alpha: 1)
        header.textLabel?.font = UIFont(name: "Avenir Next", size: 20)
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
        cell.configureCell(name: data.cafeName, address: data.cafeAddress, cityStateZip: data.cafeCityStateZip)
        if let url = URL(string: data.cafeImageURL) {
            if let imageData = try? Data(contentsOf: url) {
                cell.cafeImage.image = UIImage(data: imageData)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = favoriteCafe[indexPath.row]
        let cafeVC = self.storyboard?.instantiateViewController(withIdentifier: "CafeVC") as? CafeVC
        cafeVC?.initData(uid: data.key)
        self.present(cafeVC!, animated: true, completion: nil)
    }
}
