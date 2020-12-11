//
//  PlanViewController.swift
//  FinalProject
//
//  Created by James Monahan 
//

import UIKit
import WebKit
import GooglePlaces
import MapKit
import Contacts

class PlanViewController: UIViewController{

    @IBOutlet weak var imageView: UIImageView!
    var locationManager: CLLocationManager!
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    @IBOutlet weak var helperLabel: UILabel!
    @IBOutlet weak var restaurantButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        helperLabel.isHidden = true
        imageView.image = UIImage(named: "pointer")
        let originalImageFrame = imageView.frame
        let changeposition = CGRect(
            x: imageView.frame.origin.x,
            y: imageView.frame.origin.y - 2*imageView.frame.height,
            width: imageView.frame.width,
            height: imageView.frame.height)
        imageView.frame = changeposition
        UIView.animate(withDuration: 4.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10.0, options: [], animations: {
                    self.imageView.frame = originalImageFrame
                    self.helperLabel.isHidden = false})
    }
    @IBAction func restaurantButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let restaurantAction = UIAlertAction(title: "Restaurant", style: .default) { (_) in
            self.restaurantButton.setTitle("Restaurant", for: .normal)
            self.restaurantButton.tintColor = UIColor.yellow
            self.changeInterface()
        }
        let barAction = UIAlertAction(title: "Bar/Club", style: .default) { (_) in
            self.restaurantButton.setTitle("Bar/Club", for: .normal)
            self.restaurantButton.tintColor = UIColor.red
            self.changeInterface()
        }
        let entertainmentAction = UIAlertAction(title: "Entertainment", style: .default) { (_) in
            self.restaurantButton.setTitle("Entertainment", for: .normal)
            self.restaurantButton.tintColor = UIColor.green
            self.changeInterface()
        }
        let localAction = UIAlertAction(title: "Local Events", style: .default) { (_) in
            self.restaurantButton.setTitle("Local Events", for: .normal)
            self.restaurantButton.tintColor = UIColor.orange
            self.changeInterface()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(restaurantAction)
        alertController.addAction(barAction)
        alertController.addAction(entertainmentAction)
        alertController.addAction(localAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func changeInterface(){
        switch restaurantButton.tintColor {
        case UIColor.yellow:
            if let appURL = URL(string: "https://www.google.com/maps/search/Restaurants/@(latitude),(longtidue),13z/data=!3m1!4b1") {
                UIApplication.shared.open(appURL) { success in
                    if success {
                        print("The URL was delivered successfully.")
                    } else {
                        print("The URL failed to open.")
                    }
                }
            } else {
                print("Invalid URL specified.")
            }
        case UIColor.red:
            if let appURL = URL(string: "https://www.google.com/maps/search/bars+and+clubs/@(latitude),(longitude),12.91z/data=!4m2!2m1!6e5") {
                UIApplication.shared.open(appURL) { success in
                    if success {
                        print("The URL was delivered successfully.")
                    } else {
                        print("The URL failed to open.")
                    }
                }
            } else {
                print("Invalid URL specified.")
            }
        case UIColor.green:
            if let appURL = URL(string: "https://www.google.com/maps/search/entertainment/@(latitude),(longitude),11z/data=!3m1!4b1") {
                UIApplication.shared.open(appURL) { success in
                    if success {
                        print("The URL was delivered successfully.")
                    } else {
                        print("The URL failed to open.")
                    }
                }
            } else {
                print("Invalid URL specified.")
            }
        case UIColor.orange:
            if let appURL = URL(string: "https://www.facebook.com/events/") {
                UIApplication.shared.open(appURL) { success in
                    if success {
                        print("The URL was delivered successfully.")
                    } else {
                        print("The URL failed to open.")
                    }
                }
            } else {
                print("Invalid URL specified.")
            }
        default:
            return
        }
    }
        
}
    


extension PlanViewController: CLLocationManagerDelegate {
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
        self.latitude = currentLocation.coordinate.latitude
        self.longitude = currentLocation.coordinate.longitude
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if error != nil {
                print("😡 ERROR: retrieving place. \(error!.localizedDescription)")
            }
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                if error != nil {
                    print("😡 ERROR: retrieving place. \(error!.localizedDescription)")
                }
            self.longitude = currentLocation.coordinate.longitude
            self.latitude = currentLocation.coordinate.latitude
        }
    }
}
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: \(error.localizedDescription). Failed to get device location.")
    }
}
