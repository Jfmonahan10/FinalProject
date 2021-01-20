//
//  ProfileDetailViewController.swift
//  FinalProject
//
//  Created by James Monahan on 12/8/20.
//

import UIKit
import GooglePlaces
import MapKit
import Contacts

class ProfileDetailViewController: UIViewController{
    
    var personName = ""
    var personUserName = ""
    var personalBio = ""
    var documentID = ""
    var image: UIImage!
    var photo: Photo!
    var photos: Photos!
    var restaurant: Restaurant!
    var profileUser: ProfileUser!
    let regionDistance: CLLocationDegrees = 750.0
    var locationManager: CLLocationManager!
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var imagePickerController = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bioView: UITextView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var userName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        getLocation()
        
       

        imageView.image = image
        bioView.text = personalBio
        nameField.text = personName
        userName.text = personUserName
        imagePickerController.delegate = self
        photo = Photo()
        photos = Photos()
        if restaurant == nil {
            restaurant = Restaurant()
        }
        if profileUser == nil{
            profileUser = ProfileUser()
        }
        documentID = profileUser.documentID
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
    }
    
    func updateUserInterface(){
        nameField.text = restaurant.name
        userName.text = restaurant.username
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
       let isPresentinginAddMode = presentingViewController is UINavigationController
       if (isPresentinginAddMode) {
           dismiss(animated: true, completion: nil)
       } else{
           navigationController?.popViewController(animated: true)
       }
    }
    @IBAction func chooseYourAvatar(_ sender: UIButton) {
        cameraOrLibraryAlert()
    }
    
//    @IBAction func saveButtonPressed(_ sender: UIButton) {
//        updateUserInterface()
//        image = imageView.image
//        personalBio = bioView.text
//        personName = nameField?.text ?? "Your name will go here"
//        personUserName = userName?.text ?? "Future username here"
//        print("look here" + documentID)
//        restaurant.documentID = documentID
//        restaurant.saveData{ (success) in
//            if success {
//                self.leaveViewController()
//            } else {
//                self.oneButtonAlert(title: "Save Failed", message: "For some reason, the data would not save to the cloud")
//            }
//        }
//    }
    
//    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
   
        
//        restaurant.saveData{ (success) in
//            if success {
//                self.leaveViewController()
//            } else {
//                self.oneButtonAlert(title: "Save Failed", message: "For some reason, the data would not save to the cloud")
////            }
////        }
//    }
        
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else{
            navigationController?.popViewController(animated: true)
        }
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier ?? ""{
    case "unwindFromSave":
        personalBio = bioView.text
        personName = nameField?.text ?? "Your name will go here"
        print("This is the current personname" + personName)
        personUserName = userName?.text ?? "Future username here"
        print("This is the current username" + personUserName)
        print("look here" + documentID)
        restaurant.documentID = documentID
//        image = imageView.image
//        personalBio = bioView.text
//        personName = nameField?.text ?? "Your name will go here"
//        personUserName = userName?.text ?? "Future username here"
//        self.restaurant.saveData{ (success) in
//            self.navigationController?.setToolbarHidden(true, animated: true)
//        }
    case "AddPhoto":
        let navigationController = segue.destination as! UINavigationController
        let destination = navigationController.viewControllers.first as! PhotoViewController
        destination.restaurant = restaurant
        destination.photo = photo
    default:
        print("Couldn't find a case for segue identifier ")
    }
    }
   
    
    func cameraOrLibraryAlert() {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
                self.accessPhotoLibrary()
            }
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
                self.accessCamera()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(photoLibraryAction)
            alertController.addAction(cameraAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
    }
    
 
}

extension ProfileDetailViewController: CLLocationManagerDelegate {
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func handleAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.oneButtonAlert(title: "Location services denied", message: "It may be that parental controls are restricting location use in this app.")
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Select 'Settings' below to enable device settings and enable location services for this app.")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print("DEVELOPER ALERT: Unknown case of status in handleAuthorizationStatus \(status)")
        }
    }
    
    func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            print("Something went wrong getting the UIApplication.openSettingsURLString")
            return
        }
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (value) in
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("👮‍♀️👮‍♀️ Checking authorization status")
        handleAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last ?? CLLocation()
        print("🗺 Current location is \(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)")
        self.coordinate = currentLocation.coordinate
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if error != nil {
                print("😡 ERROR: retrieving place. \(error!.localizedDescription)")
            }
            self.coordinate = currentLocation.coordinate
            self.updateUserInterface()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: \(error.localizedDescription). Failed to get device location.")
    }
}



extension ProfileDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photo = Photo()
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            photo.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photo.image = originalImage
        }
        dismiss(animated: true) {
            self.performSegue(withIdentifier: "AddPhoto", sender: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func accessPhotoLibrary() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        } else {
            self.oneButtonAlert(title: "Camera Not Available", message: "There is no camera available on this device.")
        }
    }
}


