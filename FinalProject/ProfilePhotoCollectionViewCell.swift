//
//  ProfilePhotoCollectionViewCell.swift
//  FinalProject
//
//  Created by James Monahan on 12/8/20.
//

import UIKit
import SDWebImage

class ProfilePhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profilePhotoImage: UIImageView!
    var restaurant: Restaurant!
    var photo: Photo! {
        didSet{
            if let url = URL(string: self.photo.photoURL){
                self.profilePhotoImage.sd_imageTransition = .fade
                self.profilePhotoImage.sd_imageTransition?.duration = 0.2
                self.profilePhotoImage.sd_setImage(with: url)
            } else {
                print("URL Didn't work \(self.photo.photoURL)")
                self.photo.loadImage(restaurant : self.restaurant) {(success) in
                    self.photo.saveData(restaurant: self.restaurant) {(success) in
                        print("Image updated with URL \(self.photo.photoURL)")
                    }
                }
            }
           
        }
    }
    
}
