//
//  Photos.swift
//  FinalProject
//
//  Created by James Monahan on 12/8/20.
//

import Foundation
import Firebase

class Photos {
    var photoArray: [Photo] = []
    
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    
    func loadData(restaurant: Restaurant, completed: @escaping () -> ()) {
        guard restaurant.documentID != "" else {
            return
        }
        db.collection("users").document(restaurant.documentID).collection("photos").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("😡 ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.photoArray = []
            for document in querySnapshot!.documents {
                let photo = Photo(dictionary: document.data())
                photo.documentID = document.documentID
                self.photoArray.append(photo)
            }
            completed()
        }
    }
}
