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
    var userArray: [ProfileUser] = []
    var db: Firestore!
    var documentID: String!
    var profileUser: ProfileUser!
    
    
    init() {
        db = Firestore.firestore()
    }
    
//    func getDocument(completed: @escaping () -> ()) {
//           //Get specific document from current user
//           let docRef = Firestore.firestore()
//              .collection("users")
//              .whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")
//
//           // Get data
//           docRef.getDocuments { (querySnapshot, err) in
//               if let err = err {
//                   print(err.localizedDescription)
////               } else if querySnapshot!.documents.count != 1 {
////                   print("More than one document or none")
////               }
//               }else {
//                    self.favoriteArray = []
//                    for document in querySnapshot!.documents {
//                        let favorite = Favorite(dictionary: document.data())
//                        favorite.postingUserID = document.documentID
//                        self.favoriteArray.append(favorite)
//                    }
//                    completed()
//               }
//           }
//       }
    func loadData(completed: @escaping () -> ()) {
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print("😡 ERROR: Could not save data because we dno't have a valid postingUserID.")
            return
        }
        self.documentID = postingUserID
        db.collection("users").document(self.documentID).collection("favorites").addSnapshotListener { (querySnapshot, error) in
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
