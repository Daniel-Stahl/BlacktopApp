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
import AnyFormatKit

class CafeProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // add Marks
    var ref: DatabaseReference!
    let storage = Storage.storage().reference()
    var cafe: Cafe?

    var imageDownloadURL: String?
    var takenImage = UIImage()
    var statePicker = UIPickerView()
    let picker = UIImagePickerController()
    
    let spinner = Spinner()
    
    @IBOutlet weak var editCafeProfileButton: UIButton!
    @IBOutlet weak var saveCafeProfileButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
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
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        DatabaseService.instance.getCurrentUserCafeData(currentUser: currentUser) { (returnedCafe) in
            self.cafe = returnedCafe
            self.showcafeInfo()
        }
        
        zipcode.keyboardType = .numberPad
        statePicker.delegate = self
        state.inputView = statePicker
        picker.delegate = self
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        guard let cafeVC = self.storyboard?.instantiateViewController(withIdentifier: "CafeVC") as? CafeVC else { return }
        cafeVC.initData(uid: currentUser)
        present(cafeVC, animated: true, completion: nil)
    }
    
    @IBAction func pressedLogoutButton(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            
            do {
                try Auth.auth().signOut()
                guard let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as? WelcomeVC else { return }
                self.present(welcomeVC, animated: true, completion: nil)
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
        guard let cafePhoto = cafe?.image else { return }
        if cafePhoto == "" {
            print("photo blank")
        } else {
            guard let url = URL(string: cafePhoto) else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            self.profileImage.image = UIImage(data: imageData)
        }
        
        self.name.text = cafe?.name
        self.address.text = cafe?.address
        self.city.text = cafe?.city
        self.state.text = cafe?.state
        self.zipcode.text = cafe?.zipcode
        self.phone.text = cafe?.phone
        self.website.text = cafe?.website

        self.monOpen.text = cafe?.monOpen
        self.monClose.text = cafe?.monClose
        self.tueOpen.text = cafe?.tueOpen
        self.tueClose.text = cafe?.tueClose
        self.wedOpen.text = cafe?.wedOpen
        self.wedClose.text = cafe?.wedClose
        self.thuOpen.text = cafe?.thuOpen
        self.thuClose.text = cafe?.thuClose
        self.friOpen.text = cafe?.friOpen
        self.friClose.text = cafe?.friClose
        self.satOpen.text = cafe?.satOpen
        self.satClose.text = cafe?.satClose
        self.sunOpen.text = cafe?.sunOpen
        self.sunClose.text = cafe?.sunClose
    }
    
    @IBAction func pressedSaveButton(_ sender: Any) {
        updateUserProfile()
    }
    
    func updateUserProfile() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        spinner.startSpinner(view: view)
        let imageRef = storage.child("photos").child(currentUser)
        guard let image = self.profileImage.image, let newImage = UIImageJPEGRepresentation(image, 0.0) else { return }
        imageRef.putData(newImage, metadata: nil) { (metadata, error) in
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
                    guard let name = self.name.text, let address = self.address.text, let city = self.city.text, let state = self.state.text, let zipcode = self.zipcode.text, let phone = self.phone.text, let website = self.website.text, let monOpen = self.monOpen.text, let monClose = self.monClose.text, let tueOpen = self.tueOpen.text, let tueClose = self.tueClose.text, let wedOpen = self.wedOpen.text, let wedClose = self.wedClose.text, let thuOpen = self.thuOpen.text, let thuClose = self.thuClose.text, let friOpen = self.friOpen.text, let friClose = self.friClose.text, let satOpen = self.satOpen.text, let satClose = self.satClose.text, let sunOpen = self.sunOpen.text, let sunClose = self.sunClose.text else { return }
                    let cafeDetails = ["photoURL": profilePhotoURL, "name": name, "location": ["address": address, "city": city, "state": state, "zipcode": zipcode], "phone": phone, "website": website, "hours": ["monOpen": monOpen, "monClose": monClose, "tueOpen": tueOpen, "tueClose": tueClose, "wedOpen": wedOpen, "wedClose": wedClose, "thuOpen": thuOpen, "thuClose": thuClose, "friOpen": friOpen, "friClose": friClose, "satOpen": satOpen, "satClose": satClose, "sunOpen": sunOpen, "sunClose": sunClose]] as [String : Any]
                    
                    guard let currentUser = Auth.auth().currentUser?.uid else { return }
                    self.ref.child("users").child(currentUser).updateChildValues(cafeDetails, withCompletionBlock: { (error, ref) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        self.spinner.stopSpinner()
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
            changeSettingsAlert()
        default:
            print("Error: no access to photo album.")
        }
    }
    
    func changeSettingsAlert() {
        let alert = UIAlertController(title: "Access to photos denied", message: "please change your settings in Privacy > Photos > Blacktop", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (_) in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Setting is opened: \(success)")
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension CafeProfileVC {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
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
