//
//  Favorites.swift
//  FinalProject
//
//  Created by James Monahan
//

import Foundation
import Firebase

class Favorites {
    var favoriteArray: [Favorite] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("favorites").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("😡 ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.favoriteArray = []
            for document in querySnapshot!.documents {
                let favorite = Favorite(dictionary: document.data())
                favorite.documentID = document.documentID
                self.favoriteArray.append(favorite)
            }
            completed()
        }
    }
}
