//
//  Photo.swift
//  FinalProject
//
//  Created by James Monahan on 12/8/20.
//

import UIKit
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var photoUserID: String
    var photoUserEmail: String
    var date: Date
    var photoURL: String
    var documentID:String
    
  
    
    
    
    var dictionary: [String: Any]{
        let timeIntervalDate = date.timeIntervalSince1970
        return ["description": description, "photoUserID": photoUserID,
                "photoUserEmail": photoUserEmail, "data": timeIntervalDate, "photoURL": photoURL]
    }
    
    init(image: UIImage, description: String, photoUserID: String, photoUserEmail: String, date: Date, photoURL: String, documentID:String){
        self.image = image
        self.description = description
        self.photoUserID = photoUserID
        self.photoUserEmail = photoUserEmail
        self.date = date
        self.photoURL = photoURL
        self.documentID = documentID
    }

    
    convenience init(){
        let photoUserID = Auth.auth().currentUser?.uid ?? ""
        let photoUserEmail = Auth.auth().currentUser?.email ?? "unknown email"
        self.init(image: UIImage(), description: "", photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: Date(), photoURL: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"] as! String? ?? ""
        let photoUserID = dictionary["photoUserID"] as! String? ?? ""
        let photoUserEmail = dictionary["photoUserEmail"] as! String? ?? ""
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        let photoURL = dictionary["photoURL"] as! String? ?? ""
    
        self.init(image: UIImage(), description: description, photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: date, photoURL: photoURL, documentID: "")
        }
    
    func saveData(restaurant: Restaurant, completion: @escaping (Bool) -> ()) {
            print("does it get to the save function")
            let storage = Storage.storage()
            guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
                print("Error: Could not convert photo.image to Data.")
                return
            }
            let uploadMetaData = StorageMetadata()
            uploadMetaData.contentType = "image/jpeg"
            if documentID == "" {
                documentID = UUID().uuidString
            }
        
            print("Line 71")
            let storageRef = storage.reference().child(restaurant.documentID).child(documentID)
            print("line 73")
            let uploadTask = storageRef.putData(photoData, metadata: uploadMetaData) { (metadata, error) in
                if let error = error {
                    print("Error: upload for ref \(uploadMetaData) failed. \(error.localizedDescription)")
                }
            }
            uploadTask.observe(.success) { (snapshot) in
                print("Upload to Firebase Storage was successful!")
                storageRef.downloadURL {(url, error) in
                    guard error == nil else {
                        print("Error: Couldn't create a download url \(error?.localizedDescription ?? "")")
                        return completion(false)
                    }
                    guard let url = url else {
                        print("Error: url was nill and this should not have happened because we've already shown there was no error.")
                        return completion(false)
                    }
                    print("90")
                    self.photoURL = "\(url)"
                    let db = Firestore.firestore()
                    print("93")
                    let dataToSave: [String: Any] = self.dictionary
                    print("95")
                    let ref = db.collection("media").document(self.photoUserID)
                    print("97")
                    ref.setData(dataToSave) { (error) in
                        guard error == nil else {
                            print("😡 ERROR: updating document \(error!.localizedDescription)")
                            return completion(false)
                        }
                        print("103")
                        print("💨 Updated document: \(self.documentID) in profile: \(restaurant.documentID)") // It worked!
                        completion(true)
                    }
                }
                
            }
            uploadTask.observe(.failure){ (snapchot) in
                if let error = snapchot.error{
                    print("Eror: upload task for file \(self.documentID) failed, in restaurant \(restaurant.documentID), with error \(error.localizedDescription)")
                }
                completion(false)
            }
    }
    
    func loadImage(restaurant : Restaurant, completion: @escaping(Bool) -> ()){
        guard restaurant.documentID != "" else{
            print("Error: did not pass a valid spit into loadImage")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child(restaurant.documentID).child(documentID)
        storageRef.getData(maxSize: 25 * 1024 * 1024){(data, error) in
            if let error = error {
                print("Error: an error occurred while reading data from file ref:\(storageRef) error = \(error.localizedDescription)")
                return completion(false)
            } else {
                self.image = UIImage(data: data!) ?? UIImage()
                return completion(true)
            }
        }
    }
    
    func deleteData(restaurant: Restaurant, completion: @escaping(Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("users").document(restaurant.documentID).collection("photos").document(documentID).delete{(error) in
            if let error = error {
                print("Error: deleting photo documentID \(self.documentID). Error: \(error.localizedDescription)")
                completion(false)
            } else {
                self.deleteImage(restaurant: restaurant)
                print("Successfully deleted documentID \(self.documentID)")
                    completion(true)
            }
        }
    }
    private func deleteImage(restaurant:Restaurant){
        guard restaurant.documentID != "" else{
            print("Error: did not pass a valid restaurant into deleteImage")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child(restaurant.documentID).child(documentID)
        storageRef.delete {error in
            if let error = error{
                print("Error: Could not delete photo \(error.localizedDescription)")
            } else {
                print("Photo successfully deleted!")
            }
        }
    }
}
