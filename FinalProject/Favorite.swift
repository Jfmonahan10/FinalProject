//
//  Favorite.swift
//  FinalProject
//
//  Created by James Monahan
//


import Foundation
import UIKit
import Firebase



class Favorite: NSObject {
    
    var name: String
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["name": name,  "postingUserID": postingUserID]
    }
    
    var title: String? {
        return name
    }
    
  

    init(name: String, postingUserID: String, documentID: String){
        self.name = name
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    override convenience init(){
        self.init(name: "", postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
            let name = dictionary["name"] as! String? ?? ""
            let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(name: name, postingUserID: postingUserID, documentID: "")
    }
    

    func saveData(completion: @escaping (Bool) -> ()) {
            let db = Firestore.firestore()
            // Grab the user ID
            guard let postingUserID = Auth.auth().currentUser?.uid else {
                print("😡 ERROR: Could not save data because we dno't have a valid postingUserID.")
                return completion(false)
            }
            self.postingUserID = postingUserID
            // Create the dictionary representing data we want to save
            let dataToSave: [String: Any] = self.dictionary
            // if we HAVE saved a record, we'll have an ID, otherwise .addDocument will create one.
            if self.documentID == "" { // Create a new document via .addDocument
                var ref: DocumentReference? = nil // Firestore will create a new ID for us
                ref = db.collection("users").document(self.postingUserID).collection("favorites").addDocument(data: dataToSave){ (error) in
                    guard error == nil else {
                        print("😡 ERROR: adding document \(error!.localizedDescription)")
                        return completion(false)
                    }
                    self.documentID = ref!.documentID
                    print("💨 Added document: \(self.documentID)") // It worked!
                    completion(true)
                }
            } else { // else save to the existing documentID w/.setData
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(documentID)
                let ref = userRef.collection("favorites").document(self.documentID)
                ref.setData(dataToSave) { (error) in
                    guard error == nil else {
                        print("😡 ERROR: updating document \(error!.localizedDescription)")
                        return completion(false)
                    }
                    print("💨 Updated document: \(self.documentID)") // It worked!
                    completion(true)
                }
            }
        }
    
    func deleteData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("favorites").document(self.documentID).delete{(error) in
            if let error = error {
                print("Error: deleting photo documentID \(self.documentID). Error: \(error.localizedDescription)")
                completion(false)
            } else {
                self.deleteValues()
                print("Successfully deleted documentID \(self.documentID)")
                    completion(true)
            }
        }
    }
    private func deleteValues(){
        guard self.documentID != "" else{
            print("Error: did not pass a valid favorite into deleteValue")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child(self.documentID)
        storageRef.delete {error in
            if let error = error{
                print("Error: Could not delete value \(error.localizedDescription)")
            } else {
                print("Value successfully deleted!")
            }
        }
    }
} 
