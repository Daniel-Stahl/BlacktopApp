//
//  CafeProfile.swift
//  Blacktop
//
//  Created by Daniel Stahl on 5/21/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
import Firebase

class CafeProfileVC: UIViewController {
    var ref: DatabaseReference!
    let currentUser = Auth.auth().currentUser?.uid
    
    let storage = Storage.storage().reference()
    
    @IBOutlet weak var editCafeProfileButton: UIButton!
    @IBOutlet weak var saveCafeProfileButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    var takenImage: UIImage!
    var imageDownloadURL: String?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        showcafeInfo()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        let imageRef = storage.child("photos").child(currentUser!)
        let downloadTask = imageRef.getData(maxSize: 1024 * 1024) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                self.profileImage.image = image
            }
            print(error ?? "No error")
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
            guard let data = Datasnapshot.value as? [String: Any] else { return }
            let cafeAddress = data["address"] as? String
            let cafeCity = data["city"] as? String
            let cafeState = data["state"] as? String
            let cafeZipcode = data["zipcode"] as? String
            
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
        if takenImage != nil {
            let imageData = UIImageJPEGRepresentation(takenImage, 0.0)
            let imageRef = storage.child("photos").child(currentUser!)
            
            imageRef.putData(imageData!).observe(.success) { (Imagesnapshot) in
                self.imageDownloadURL = Imagesnapshot.metadata?.downloadURL()?.absoluteString
            }
        } else {
            print("takenImage is nil")
        }
        
        let cafeDetails = ["name": name.text!, "location": ["address": address.text!, "city": city.text!, "state": state.text!, "zipcode": zipcode.text!], "phone": phone.text!, "website": website.text!, "hours": ["monOpen": monOpen.text!, "monClose": monClose.text!, "tueOpen": tueOpen.text!, "tueClose": tueClose.text!, "wedOpen": wedOpen.text!, "wedClose": wedClose.text!, "thuOpen": thuOpen.text!, "thuClose": thuClose.text!, "friOpen": friOpen.text!, "friClose": friClose.text!, "satOpen": satOpen.text!, "satClose": satClose.text!, "sunOpen": sunOpen.text!, "sunClose": sunClose.text!]] as [String : Any]
        
        ref.child("users").child(currentUser!).updateChildValues(cafeDetails)
            
        self.changeImageButton.isHidden = true
        self.editCafeProfileButton.isHidden = false
        self.saveCafeProfileButton.isHidden = true
        disableTextField()
    }
    
    @IBAction func pressedChangeImageButton(_ sender: Any) {
        showImageSheet()
    }
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraController = UIImagePickerController()
            cameraController.delegate = self
            cameraController.sourceType = .camera
            self.present(cameraController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryController = UIImagePickerController()
            photoLibraryController.delegate = self
            photoLibraryController.sourceType = .photoLibrary
            self.present(photoLibraryController, animated: true, completion: nil)
        }
    }
    
    func showImageSheet() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
}

extension CafeProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageBG = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.takenImage = imageBG
        self.profileImage.image = takenImage
        self.dismiss(animated: true, completion: nil)
        //TO-DO: If user uploads a larger image that can write then notify user image is to large
    }
}

extension CafeProfileVC {
    func disableTextField() {
        name.isEnabled = false
        address.isEnabled = false
        city.isEnabled = false
        state.isEnabled = false
        zipcode.isEnabled = false
        phone.isEnabled = false
        website.isEnabled = false
        monOpen.isEnabled = false
        monClose.isEnabled = false
        tueOpen.isEnabled = false
        tueClose.isEnabled = false
        wedOpen.isEnabled = false
        wedClose.isEnabled = false
        thuOpen.isEnabled = false
        thuClose.isEnabled = false
        friOpen.isEnabled = false
        friClose.isEnabled = false
        satOpen.isEnabled = false
        satClose.isEnabled = false
        sunOpen.isEnabled = false
        sunClose.isEnabled = false
    }
    
    func enableTextField() {
        name.isEnabled = true
        address.isEnabled = true
        city.isEnabled = true
        state.isEnabled = true
        zipcode.isEnabled = true
        phone.isEnabled = true
        website.isEnabled = true
        monOpen.isEnabled = true
        monClose.isEnabled = true
        tueOpen.isEnabled = true
        tueClose.isEnabled = true
        wedOpen.isEnabled = true
        wedClose.isEnabled = true
        thuOpen.isEnabled = true
        thuClose.isEnabled = true
        friOpen.isEnabled = true
        friClose.isEnabled = true
        satOpen.isEnabled = true
        satClose.isEnabled = true
        sunOpen.isEnabled = true
        sunClose.isEnabled = true
    }
}
