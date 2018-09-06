//
//  CafeVC.swift
//  Blacktop
//
//  Created by Daniel Stahl on 7/9/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase

class CafeVC: UIViewController, UIGestureRecognizerDelegate {
    var ref: DatabaseReference!
    let storage = Storage.storage().reference()
    
    @IBOutlet weak var cafeImage: UIImageView!
    @IBOutlet weak var cafeName: UILabel!
    @IBOutlet weak var cafeAddress: UILabel!
    @IBOutlet weak var cafeCityStateZip: UILabel!
    @IBOutlet weak var cafePhone: UILabel!
    @IBOutlet weak var cafeWebsite: UILabel!
    @IBOutlet weak var cafeHours: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var favoriteCafeButton: UIButton!
    @IBOutlet weak var filledFavoriteCafeButton: UIButton!
    @IBOutlet weak var addCoffeeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var cafe: Cafe?
    var coffeeBean = [CoffeeBean]()

    var cafeID: String = ""
    func initData(uid: String) {
        self.cafeID = uid
    }
    
    var favoriteImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        DatabaseService.instance.getCurrentUserCafeData(currentUser: cafeID) { (returnedCafe) in
            self.cafe = returnedCafe
            self.loadProfile()
        }
        
        DatabaseService.instance.getCoffeeBeans(passedUID: cafeID) { (returnedCoffeeBeans) in
            self.coffeeBean = returnedCoffeeBeans
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let linkTap = UITapGestureRecognizer(target: self, action: #selector(tappedLink))
        linkTap.numberOfTapsRequired = 1
        cafeWebsite.addGestureRecognizer(linkTap)
        
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(tappedPhone))
        phoneTap.numberOfTapsRequired = 1
        cafePhone.addGestureRecognizer(phoneTap)
        
        showFavoriteButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func tappedLink() {
        let url = URL(string: "https://\(cafeWebsite.text!)")
        UIApplication.shared.open(url!)
    }
    
    @objc func tappedPhone() {
        let phoneNumber = URL(string: "tel://\(cafePhone.text!)")
        UIApplication.shared.open(phoneNumber!)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindFromCafeVC", sender: self)
    }
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toCafeProfileVC", sender: nil)
    }
    
    func showFavoriteButton() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(currentUser).observeSingleEvent(of: .value) { (Snapshot) in
            let data = Snapshot.value as! [String: Any]
            let userRole = data["role"] as! String
            
            if userRole == "cafe" {
                self.favoriteCafeButton.isHidden = true
                self.filledFavoriteCafeButton.isHidden = true
            } else {
                self.ref.child("users").child(currentUser).child("favorites").child(self.cafeID).observeSingleEvent(of: .value) { (snapshot) in
                    if snapshot.exists() {
                        self.filledFavoriteCafeButton.isHidden = false
                    } else {
                        self.filledFavoriteCafeButton.isHidden = true
                        self.favoriteCafeButton.isHidden = false
                    }
                }
            }
        }
    }
    
    @IBAction func favoriteCafeButtonPressed(_ sender: Any) {
        // fix force unwraps
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        let favoriteCafeDetails = ["imageURL": favoriteImage, "name": cafeName.text!, "location": ["address": cafeAddress.text!, "cityStateZip": cafeCityStateZip.text!]] as [String : Any]
        ref.child("users").child(currentUser).child("favorites").child(cafeID).updateChildValues(favoriteCafeDetails)
        self.favoriteCafeButton.isHidden = true
        self.filledFavoriteCafeButton.isHidden = false
    }
    
    @IBAction func filledFavoriteCafeButtonPressed(_ sender: Any) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(currentUser).child("favorites").child(cafeID).removeValue()
        self.filledFavoriteCafeButton.isHidden = true
        self.favoriteCafeButton.isHidden = false
    }
    
    func loadProfile() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        if let cafePhoto = self.cafe?.image {
            let url = URL(string: cafePhoto)
            let imageData = try? Data(contentsOf: url!)
            self.cafeImage.image = UIImage(data: imageData!)
            self.favoriteImage = cafePhoto
        }
        
        let userRole = cafe?.role
        self.cafeName.text = cafe?.name
        let address = cafe?.address
        let city = cafe?.city
        let state = cafe?.state
        let zipcode = cafe?.zipcode
        self.cafePhone.text = cafe?.phone
        self.cafeWebsite.text = cafe?.website

        if userRole == "cafe" && self.cafeID == currentUser {
            self.editProfileButton.isHidden = false
            self.addCoffeeButton.isHidden = false
            self.favoriteCafeButton.isHidden = true
            self.filledFavoriteCafeButton.isHidden = true
        } else {
            self.editProfileButton.isHidden = true
            self.addCoffeeButton.isHidden = true
        }

        if address == "" && city == "" && state == "" && zipcode == "" {
            self.cafeAddress.text = ""
            self.cafeCityStateZip.text = ""
        } else {
            self.cafeAddress.text = address
            self.cafeCityStateZip.text = "\(city!), \(state!) \(zipcode!)"
        }
        
        let mondayOpen = cafe?.monOpen
        let mondayClose = cafe?.monClose
        let tuesdayOpen = cafe?.tueOpen
        let tuesdayClose = cafe?.tueClose
        let wednesdayOpen = cafe?.wedOpen
        let wednesdayClose = cafe?.wedClose
        let thursdayOpen = cafe?.thuOpen
        let thursdayClose = cafe?.thuClose
        let fridayOpen = cafe?.friOpen
        let fridayClose = cafe?.friClose
        let saturdayOpen = cafe?.satOpen
        let saturdayClose = cafe?.satClose
        let sundayOpen = cafe?.sunOpen
        let sundayClose = cafe?.sunClose

        let dayOfTheWeek = "\(Date().dayOfWeek()!)"

        switch dayOfTheWeek {
            case "Monday": if mondayOpen == "" && mondayClose == "" {
                self.cafeHours.text = "Closed"
            } else {
                self.cafeHours.text = "Today \(mondayOpen!) - \(mondayClose!)"
            }
            case "Tuesday": if tuesdayOpen == "" && tuesdayClose == "" {
                self.cafeHours.text = "Closed"
            } else {
                self.cafeHours.text = "Today \(tuesdayOpen!) - \(tuesdayClose!)"
            }
            case "Wednesday": if wednesdayOpen == "" && wednesdayClose == "" {
                self.cafeHours.text = "Closed"
            } else {
               self.cafeHours.text = "Today \(wednesdayOpen!) - \(wednesdayClose!)"
            }
            case "Thursday": if thursdayOpen == "" && thursdayClose == "" {
                self.cafeHours.text = "Closed"
            } else {
                self.cafeHours.text = "Today \(thursdayOpen!) - \(thursdayClose!)"
            }
            case "Friday": if fridayOpen == "" && fridayClose == "" {
                self.cafeHours.text = "Closed"
            } else {
                self.cafeHours.text = "Today \(fridayOpen!) - \(fridayClose!)"
            }
            case "Saturday": if saturdayOpen == "" && saturdayClose == "" {
                self.cafeHours.text = "Closed"
            } else {
                self.cafeHours.text = "Today \(saturdayOpen!) - \(saturdayClose!)"
            }
            case "Sunday": if sundayOpen == "" && sundayClose == "" {
                self.cafeHours.text = "Closed"
            } else {
                self.cafeHours.text = "Today \(sundayOpen!) - \(sundayClose!)"
            }
                default: self.cafeHours.text = "Not open"
        }
    }
}

extension CafeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffeeBean.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeBeanCell", for: indexPath) as? CoffeeBeanCell else { return UITableViewCell() }
        let data = coffeeBean[indexPath.row]
        cell.configureCell(name: data.beanName, roaster: data.roasterName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let currentUser = Auth.auth().currentUser?.uid else { return false }
        if currentUser != cafeID {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let beanData = coffeeBean[indexPath.row]
            
            ref.child("users").child(currentUser).child("beans").child(beanData.key).removeValue()
            coffeeBean.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
        }
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        
    }
}
