//
//  ProfileUsers.swift
//  FinalProject
//
//  Created by James Monahan
//
import Foundation
import Firebase

class ProfileUsers {

    
    var userArray: [ProfileUser] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            } 
            self.userArray = []
            for document in querySnapshot!.documents {
                let profileUser = ProfileUser(dictionary: document.data())
                profileUser.documentID = document.documentID
                self.userArray.append(profileUser)
            }
            completed()
        }
    }
}
