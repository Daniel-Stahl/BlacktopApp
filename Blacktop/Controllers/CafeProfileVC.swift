//
//  CafeProfile.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/21/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase
import Photos

class CafeProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var ref: DatabaseReference!
    let currentUser = Auth.auth().currentUser?.uid
    
    let storage = Storage.storage().reference()
    
    @IBOutlet weak var editCafeProfileButton: UIButton!
    @IBOutlet weak var saveCafeProfileButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    
    var imageDownloadURL: String?
    var takenImage = UIImage()
    var statePicker = UIPickerView()
    let picker = UIImagePickerController()
    
    var screenSize = UIScreen.main.bounds
    var spinner: UIActivityIndicatorView?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var website: UITextField!
    
    @IBOutlet weak var monOpen: TimePicker!
    @IBOutlet weak var monClose: TimePicker!
    @IBOutlet weak var tueOpen: TimePicker!
    @IBOutlet weak var tueClose: TimePicker!
    @IBOutlet weak var wedOpen: TimePicker!
    @IBOutlet weak var wedClose: TimePicker!
    @IBOutlet weak var thuOpen: TimePicker!
    @IBOutlet weak var thuClose: TimePicker!
    @IBOutlet weak var friOpen: TimePicker!
    @IBOutlet weak var friClose: TimePicker!
    @IBOutlet weak var satOpen: TimePicker!
    @IBOutlet weak var satClose: TimePicker!
    @IBOutlet weak var sunOpen: TimePicker!
    @IBOutlet weak var sunClose: TimePicker!
    
    var states = [
        "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        showcafeInfo()
        zipcode.keyboardType = UIKeyboardType.numberPad
        
        statePicker.delegate = self
        state.inputView = statePicker
        
        picker.delegate = self
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
        let cafeVC = self.storyboard?.instantiateViewController(withIdentifier: "CafeVC") as? CafeVC
        cafeVC?.initData(uid: currentUser!)
        self.present(cafeVC!, animated: true, completion: nil)
    }
    
    @IBAction func pressedLogoutButton(_ sender: Any) {
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
        logoutPopup.addAction(logoutAction)
        logoutPopup.addAction(logoutCancel)
        present(logoutPopup, animated: true, completion: nil)
    }
    
    @IBAction func pressedEditButton(_ sender: Any) {
        changeImageButton.isHidden = false
        editCafeProfileButton.isHidden = true
        saveCafeProfileButton.isHidden = false
        enableTextField()
    }
    
    func showcafeInfo() {
        ref.child("users").child(currentUser!).observe(.value) { (Datasnapshot) in
            let data = Datasnapshot.value as? NSDictionary
            if let cafePhoto = data?["photoURL"] as? String {
                let url = URL(string: cafePhoto)
                let imageData = try? Data(contentsOf: url!)
                self.profileImage.image = UIImage(data: imageData!)
            }
        }
        
        ref.child("users").child(currentUser!).observe(.value) { (Datasnapshot) in
            guard let data = Datasnapshot.value as? [String: Any] else { return }
            let cafeName = data["name"] as? String
            let cafePhone = data["phone"] as? String
            let cafeWebsite = data["website"] as? String
            
            self.name.text = cafeName
            self.phone.text = cafePhone
            self.website.text = cafeWebsite
        }
        
        ref.child("users").child(currentUser!).child("location").observe(.value) { (Datasnapshot) in
            let data = Datasnapshot.value as? NSDictionary
            guard let cafeAddress = data?["address"] as? String,
            let cafeCity = data?["city"] as? String,
            let cafeState = data?["state"] as? String,
            let cafeZipcode = data?["zipcode"] as? String else { return }
            
            self.address.text = cafeAddress
            self.city.text = cafeCity
            self.state.text = cafeState
            self.zipcode.text = cafeZipcode
        }
        
        ref.child("users").child(currentUser!).child("hours").observe(.value) { (Datasnapshot) in
            guard let data = Datasnapshot.value as? [String: Any] else { return }
            let monCafeOpen = data["monOpen"] as? String
            let monCafeClose = data["monClose"] as? String
            let tueCafeOpen = data["tueOpen"] as? String
            let tueCafeClose = data["tueClose"] as? String
            let wedCafeOpen = data["wedOpen"] as? String
            let wedCafeClose = data["wedClose"] as? String
            let thuCafeOpen = data["thuOpen"] as? String
            let thuCafeClose = data["thuClose"] as? String
            let friCafeOpen = data["friOpen"] as? String
            let friCafeClose = data["friClose"] as? String
            let satCafeOpen = data["satOpen"] as? String
            let satCafeClose = data["satClose"] as? String
            let sunCafeOpen = data["sunOpen"] as? String
            let sunCafeClose = data["sunClose"] as? String
            
            self.monOpen.text = monCafeOpen
            self.monClose.text = monCafeClose
            self.tueOpen.text = tueCafeOpen
            self.tueClose.text = tueCafeClose
            self.wedOpen.text = wedCafeOpen
            self.wedClose.text = wedCafeClose
            self.thuOpen.text = thuCafeOpen
            self.thuClose.text = thuCafeClose
            self.friOpen.text = friCafeOpen
            self.friClose.text = friCafeClose
            self.satOpen.text = satCafeOpen
            self.satClose.text = satCafeClose
            self.sunOpen.text = sunCafeOpen
            self.sunClose.text = sunCafeClose
        }
    }
    
    @IBAction func pressedSaveButton(_ sender: Any) {
        updateUserProfile()
    }
    
    func updateUserProfile() {
        addSpinner()
        let imageRef = storage.child("photos").child(currentUser!)
        guard let image = self.profileImage.image else { return }
        if let newImage = UIImageJPEGRepresentation(image, 0.0) {
            imageRef.putData(newImage, metadata: nil) { (metadata, error) in
                print(metadata)
                if error != nil {
                    print(error!)
                    return
                }
                imageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let profilePhotoURL = url?.absoluteString {
                        let cafeDetails = ["photoURL": profilePhotoURL, "name": self.name.text!, "location": ["address": self.address.text!, "city": self.city.text!, "state": self.state.text!, "zipcode": self.zipcode.text!], "phone": self.phone.text!, "website": self.website.text!, "hours": ["monOpen": self.monOpen.text!, "monClose": self.monClose.text!, "tueOpen": self.tueOpen.text!, "tueClose": self.tueClose.text!, "wedOpen": self.wedOpen.text!, "wedClose": self.wedClose.text!, "thuOpen": self.thuOpen.text!, "thuClose": self.thuClose.text!, "friOpen": self.friOpen.text!, "friClose": self.friClose.text!, "satOpen": self.satOpen.text!, "satClose": self.satClose.text!, "sunOpen": self.sunOpen.text!, "sunClose": self.sunClose.text!]] as [String : Any]
                        
                        self.ref.child("users").child(self.currentUser!).updateChildValues(cafeDetails, withCompletionBlock: { (error, ref) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            self.stopSpinner()
                            self.changeImageButton.isHidden = true
                            self.editCafeProfileButton.isHidden = false
                            self.saveCafeProfileButton.isHidden = true
                            self.disableTextField()
                            print("Profile successfully updated!")
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func pressedChangeImageButton(_ sender: Any) {

        checkPermission {
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        }
    }
    
    func checkPermission(handler: @escaping () -> Void) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            handler()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    handler()
                }
            }
        case .denied:
            print("please change your settings in privacy > photos > Blacktop")
            //alert user to change setting
        default:
            print("Error: no access to photo album.")
        }
    }
}

extension CafeProfileVC {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.takenImage = image
        self.profileImage.image = takenImage
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension CafeProfileVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        state.text = states[row]
    }
}
