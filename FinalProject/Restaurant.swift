//
//  Restaurant.swift
//  FinalProject
//
//  Created by James Monahan on 12/10/20.
//

import Foundation
import Firebase
import MapKit

class Restaurant: NSObject, MKAnnotation {
    var name: String
    var username: String
    var coordinate: CLLocationCoordinate2D
    var documentID: String
    var postingUserID: String

    
   
    
    var dictionary: [String: Any] {
        return ["name": name, "username": username, "latitude": latitude, "longitude": longitude, "postingUserID": postingUserID]
    }

    var latitude: CLLocationDegrees{
        return coordinate.latitude
    }

    var longitude: CLLocationDegrees{
        return coordinate.longitude
    }

    var location: CLLocation{
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    var title: String? {
        return name
    }

    var subtitle: String? {
        return username
    }
    
    

    init(name: String, username: String, coordinate: CLLocationCoordinate2D, documentID: String, postingUserID: String){
        self.name = name
        self.username = username
        self.coordinate = coordinate
        self.documentID = documentID
        self.postingUserID = postingUserID
 
    }

    override convenience init(){
        self.init(name: "", username: "", coordinate: CLLocationCoordinate2D(), documentID: "", postingUserID: "")
    }

    convenience init(dictionary: [String: Any]) {
            let name = dictionary["name"] as! String? ?? ""
            let username = dictionary["username"] as! String? ?? ""
            let latitude = dictionary["latitude"] as! Double? ?? 0
            let longitude = dictionary["longitude"] as! Double? ?? 0
            let postingUserID = dictionary["postingUserID"] as! String? ?? ""
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.init(name: name, username: username, coordinate: coordinate, documentID: "", postingUserID: postingUserID)
        }

    func saveData(completion: @escaping (Bool) -> ()) {
            let db = Firestore.firestore()
        print("This is the name entering " + name)
            // Grab the user ID
            guard let postingUserID = Auth.auth().currentUser?.uid else {
                print("😡 ERROR: Could not save data because we dno't have a valid postingUserID.")
                return completion(false)
            }
            self.postingUserID = postingUserID
            // Create the dictionary representing data we want to save
            let dataToSave: [String: Any] = self.dictionary
            // if we HAVE saved a record, we'll have an ID, otherwise .addDocument will create one.
            print("this will determine the line that causes the error")
        if self.postingUserID == "" {
                // Create a new document via .addDocument
            print("84")
                var ref: DocumentReference? = nil // Firestore will create a new ID for us
                ref = db.collection("users").addDocument(data: dataToSave){ (error) in
                    guard error == nil else {
                        print("😡 ERROR: adding document \(error!.localizedDescription)")
                        return completion(false)
                    }
                    self.documentID = ref!.documentID
                    print(self.documentID)
                    print("💨 Added document: \(self.documentID)") // It worked!
                    completion(true)
                }
            } else { // else save to the existing documentID w/.setData
                print("97")
                let ref = db.collection("profile").document(self.postingUserID)
                ref.setData(dataToSave) { (error) in
                    guard error == nil else {
                        print("😡 ERROR: updating document \(error!.localizedDescription)")
                        return completion(false)
                    }
                    print("💨 Updated document: \(self.documentID)") // It worked!
                    completion(true)
                    print("This is the " + self.name)
                }
            }
    }
        
    

//    func updateProfile(completed: @escaping() -> ()) {
//            let db = Firestore.firestore()
//            let reviewsRef = db.collection("profile").document(documentID).collection("personalInformation")
//            reviewsRef.getDocuments { (querySnapshot, error) in
//                guard error == nil else {
//                    print("Error: failed to get query snapshot of reviews for reviewsRef \(reviewsRef)")
//                    return completed()
//                }
//                var ratingTotal = 0.0
//                for document in querySnapshot!.documents {
//                    let reviewDictionary = document.data()
//                    let rating = reviewDictionary["rating"] as! Int? ?? 0
//                    ratingTotal = ratingTotal + Double(rating)
//                }
//                self.averageRating = ratingTotal / Double(querySnapshot!.count)
//                self.numberOfReviews = querySnapshot!.count
//                let dataToSave = self.dictionary
//                let spotRef = db.collection("spots").document(self.documentID)
//                spotRef.setData(dataToSave) { (error) in
//                    if let error = error {
//                        print("Error: updating document \(self.documentID) in spot after changing averageReview & numberOfReviews info \(error.localizedDescription)")
//                        completed()
//                    } else {
//                        print("New average \(self.averageRating). Document updated with ref ID \(self.documentID)")
//                        completed()
//                    }
//                }
//            }
//        }
}

