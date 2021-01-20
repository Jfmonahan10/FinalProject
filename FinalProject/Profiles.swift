//
//  Profiles.swift
//  FinalProject
//
//  Created by James Monahan on 12/10/20.
//

import Foundation
import Firebase
import MapKit

class Profiles {
    var db: Firestore!
    var restaurant = Restaurant()
    var name = ""
    var username = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var documentID = ""
    var postingUserID = ""
    
    
    
    init() {
        db = Firestore.firestore()
    }
    
    var title: String? {
        return name
    }
    
    func loadData(documentID: String) {
        print("21")
        print(self.documentID)
        let doc = db.collection("profile").document(documentID)
        print("24")
        doc.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data() ?? [String: Any]()
                print("28")
                self.convert(dictionary: dataDescription)
                
                print("Document data: \(dataDescription)")
                
            } else {
                print("Document does not exist")
            }
        }
        print(self.documentID)
    }
    
    func convert( dictionary: [String: Any]){
        let vc = ProfileViewController()
        for (key, value) in dictionary{
            if key == "latitude"{
                self.coordinate.latitude = value as! Double
                vc.coordinate.latitude = self.coordinate.latitude
                print(self.coordinate.latitude)
            }
            else if key == "name"{
                self.name = value as! String
                vc.textholder = self.name
                print(vc.textholder)
        
            }else if key == "username"{
                self.username = value as! String
                vc.usernameholder = self.username
                print(self.username)
                print(vc.usernameholder)
            }
            else if key == "postingUserID"{
                self.postingUserID = value as! String
            }
            else if key == "longitude"{
                self.coordinate.longitude = value as! Double
            }
        }
    }
}
