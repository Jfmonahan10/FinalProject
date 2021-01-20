//
//  ProfileViewController.swift
//  FinalProject
//
//  Created by James Monahan on 12/8/20.
//

import UIKit
import GooglePlaces
import MapKit
import Contacts

class ProfileViewController: UIViewController{

    var textholder = ""
    var usernameholder = ""
    @IBOutlet weak var personalImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signOutBarButton: UIBarButtonItem!
    @IBOutlet weak var collectionViewProfile: UICollectionView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var segmentTabControl: UISegmentedControl!
    var restaurant: Restaurant!
    var photo: Photo!
    var photos: Photos!
    var profile: Profiles!
    var profileUsers: ProfileUsers!
    var documentID = ""
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var counter = 0
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        
        restaurant = Restaurant()
        profile = Profiles()
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        //profile.loadData(documentID: profile.documentID)
        print("This is wack" + profile.title!)
        print(textholder)
        nameLabel.text = textholder
        usernameLabel.text = usernameholder
        if profile == nil{
            bioTextView.text = "This is where your bio will display once you have entered information about yourself."
            nameLabel.text = "Your name will go here"
            usernameLabel.text = "Future username here"
            personalImage.image = UIImage(systemName: "person")
        } else if counter == 0{
            counter = 1
        }
    }
        
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? ""{
//        case "AddPhoto":
//            let navigationController = segue.destination as! UINavigationController
//            let destination = navigationController.viewControllers.first as! PhotoViewController
//            destination.spot = spot
//            destination.photo = photo
//        case "ShowPhoto":
//            let destination = segue.destination as! PhotoViewController
//            guard let selectedIndexPath = collectionViewProfile.indexPathsForSelectedItems?.first
//            else{
//                print("Error: couldn't get selected collectionView item.")
//                return
//            }
//            destination.photo = photos.photoArray[selectedIndexPath.row]
//            destination.spot = spot
        case "ProfileDetail":
            let destination = segue.destination as! ProfileDetailViewController
            if nameLabel.text == "Your name will go here"{
                destination.personName = ""
            } else {
                destination.personName = nameLabel.text!
            }
            if usernameLabel.text == "Future username here"{
                destination.personUserName = ""
            } else {
                destination.personUserName = usernameLabel.text!
            }
            if bioTextView.text == "This is where your bio will display once you have entered information about yourself."{
                destination.personalBio = ""
            } else {
                destination.personalBio = bioTextView.text
            }
            destination.image = personalImage.image
        default:
            print("Couldn't find a case for segue identifier ")
        }
        
    }
    
    @IBAction func unwindFromProfileDetailViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! ProfileDetailViewController
        nameLabel.text = source.personName
        print("Is this weird" + source.personName)
        usernameLabel.text = source.personUserName
        bioTextView.text = source.bioView.text!
        personalImage.image = source.image
        restaurant.name = source.personName
        print("restaurant name" + restaurant.name)
        print("restaurant username" + restaurant.username)
        restaurant.username = source.personUserName
        restaurant.coordinate = source.coordinate
        print(restaurant.name)
        restaurant.saveData{ _ in }
    }
    
//    @IBAction func addPhotoButton(_ sender: UIButton) {
//            cameraOrLibraryAlert()
//    }
//
    
    @IBAction func statusButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let marriedAction = UIAlertAction(title: "Married", style: .default) { (_) in
            self.statusButton.setTitle("Married", for: .normal)
        }
        let datingAction = UIAlertAction(title: "Dating", style: .default) { (_) in
            self.statusButton.setTitle("Dating", for: .normal)
        }
        let singleAction = UIAlertAction(title: "Single", style: .default) { (_) in
            self.statusButton.setTitle("Single", for: .normal)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(marriedAction)
        alertController.addAction(datingAction)
        alertController.addAction(singleAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func genderButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let maleAction = UIAlertAction(title: "Male", style: .default) { (_) in
            self.genderButton.setTitle("Male", for: .normal)
        }
        let femaleAction = UIAlertAction(title: "Female", style: .default) { (_) in
            self.genderButton.setTitle("Female", for: .normal)
        }
        let otherAction = UIAlertAction(title: "Other", style: .default) { (_) in
            self.genderButton.setTitle("Other", for: .normal)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(maleAction)
        alertController.addAction(femaleAction)
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func friendsButtonPressed(_ sender: UIButton) {
    }
    @IBAction func editProfilePressed(_ sender: Any) {
    }
  
    @IBAction func segmentButtonPressed(_ sender: UISegmentedControl) {
        switch segmentTabControl.selectedSegmentIndex{
        case 1:
            performSegue(withIdentifier: "PlanSegue", sender: nil)
        case 2:
            performSegue(withIdentifier: "PrivateEventsSegue", sender: nil)
        case 3:
            performSegue(withIdentifier: "NotificationsSegue", sender: nil)
        case 4:
            performSegue(withIdentifier: "PlacesSegue", sender: nil)
        default:
            return
        }
    }
    
    
}

