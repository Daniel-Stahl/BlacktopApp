//
//  CafeVC.swift
//  Blacktop
//
//  Created by Daniel Stahl on 7/9/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase

class CafeVC: UIViewController {
    var ref: DatabaseReference!
    let storage = Storage.storage().reference()
    let currentUser = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var cafeImage: UIImageView!
    @IBOutlet weak var cafeName: UILabel!
    @IBOutlet weak var cafeAddress: UILabel!
    @IBOutlet weak var cafeCityStateZip: UILabel!
    @IBOutlet weak var cafePhone: UILabel!
    @IBOutlet weak var cafeWebsite: UILabel!
    @IBOutlet weak var cafeHours: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var addCoffeeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var coffeeBean = [CoffeeBean]()
    
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
        loadProfile()
        FirebaseService.instance.getCoffeeBeans(passedUID: passedCafeID) { (returnedCoffeeBeans) in
            self.coffeeBean = returnedCoffeeBeans
            self.tableView.reloadData()
        }
        //getCoffeeBeans()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "CafeProfileVC")
        self.present(profileVC!, animated: true, completion: nil)
    }
    
    func loadProfile() {
        ref.child("users").child(passedCafeID).observeSingleEvent(of: .value) { (Snapshot) in
            let data = Snapshot.value as! [String: Any]
            let userRole = data["role"] as! String
            
            if userRole == "cafe" && self.passedCafeID == self.currentUser {
                self.editProfileButton.isHidden = false
                self.addCoffeeButton.isHidden = false
            } else {
                self.editProfileButton.isHidden = true
                self.addCoffeeButton.isHidden = true
            }
        }
        
        let imageRef = storage.child("photos").child(passedCafeID)
        let downloadTask = imageRef.getData(maxSize: 1024 * 1024) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                self.cafeImage.image = image
            }
            print(error ?? "No error")
        }
        
        ref.child("users").child(passedCafeID).observe(.value) { (Datasnapshot) in
            guard let data = Datasnapshot.value as? [String: Any] else { return }
            let name = data["name"] as? String
            let phone = data["phone"] as? String
            let website = data["website"] as? String
            
            self.cafeName.text = name
            self.cafePhone.text = phone
            self.cafeWebsite.text = website
        }
        
        ref.child("users").child(passedCafeID).child("location").observe(.value) { (Datasnapshot) in
            guard let data = Datasnapshot.value as? [String: Any] else { return }
            let address = data["address"] as? String
            let city = data["city"] as? String
            let state = data["state"] as? String
            let zipcode = data["zipcode"] as? String
            
            self.cafeAddress.text = address
            self.cafeCityStateZip.text = "\(city!), \(state!) \(zipcode!)"
        }
        
        ref.child("users").child(passedCafeID).child("hours").observe(.value) { (Datasnapshot) in
            guard let data = Datasnapshot.value as? [String: Any] else { return }
            let mondayOpen = data["monOpen"] as? String
            let mondayClose = data["monClose"] as? String
            let tuesdayOpen = data["tueOpen"] as? String
            let tuesdayClose = data["tueClose"] as? String
            let wednesdayOpen = data["wedOpen"] as? String
            let wednesdayClose = data["wedClose"] as? String
            let thursdayOpen = data["thuOpen"] as? String
            let thursdayClose = data["thuClose"] as? String
            let fridayOpen = data["friOpen"] as? String
            let fridayClose = data["friClose"] as? String
            let saturdayOpen = data["satOpen"] as? String
            let saturdayClose = data["satClose"] as? String
            let sundayOpen = data["sunOpen"] as? String
            let sundayClose = data["sunClose"] as? String
            
            let dayOfTheWeek = "\(Date().dayOfWeek()!)"
            
            switch dayOfTheWeek {
                case "Monday": self.cafeHours.text = "Today \(mondayOpen!) - \(mondayClose!)"
                case "Tuesday": self.cafeHours.text = "Today \(tuesdayOpen!) - \(tuesdayClose!)"
                case "Wednesday": self.cafeHours.text = "Today \(wednesdayOpen!) - \(wednesdayClose!)"
                case "Thursday": self.cafeHours.text = "Today \(thursdayOpen!) - \(thursdayClose!)"
                case "Friday": self.cafeHours.text = "Today \(fridayOpen!) - \(fridayClose!)"
                case "Saturday": self.cafeHours.text = "Today \(saturdayOpen!) - \(saturdayClose!)"
                case "Sunday": self.cafeHours.text = "Today \(sundayOpen!) - \(sundayClose!)"
                default: self.cafeHours.text = "Not open"
            }
        }
    }

    @IBAction func addCoffeePressed(_ sender: Any) {
        
    }
    
//    func getCoffeeBeans() {
//        var coffeeBeans = [CoffeeBean]()
//        ref.child("users").child(passedCafeID).child("beans").observe(.value) { (Datasnapshot) in
//            guard let data = Datasnapshot.children.allObjects as? [DataSnapshot] else { return }
//            for beans in data {
//                guard let beanName = beans.childSnapshot(forPath: "name").value as? String,
//                    let roasterName = beans.childSnapshot(forPath: "roaster").value as? String else { return }
//
//                let coffeeBean = CoffeeBean(beanName: beanName, roasterName: roasterName)
//                coffeeBeans.append(coffeeBean)
//                //print(beanName)
//                //print(roasterName)
//            }
//        }
//    }
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
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        
    }
}
