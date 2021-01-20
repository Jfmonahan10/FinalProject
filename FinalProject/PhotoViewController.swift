//
//  PhotoViewController.swift
//  FinalProject
//
//  Created by James Monahan on 12/8/20.
//

import UIKit
import Firebase
import SDWebImage

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

class PhotoViewController: UIViewController {

    
    var restaurant : Restaurant!
    var photo: Photo!
    
    @IBOutlet weak var authorLabels: UILabel!
    
    @IBOutlet weak var captionTextField: UITextField!
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard restaurant != nil else{
            print("Error: No restaurant passed to the PhotoViewController class.")
            return
        }
        
        if photo == nil {
            photo = Photo()
        }
        
        updateUserInterface()
    }
    
    func updateUserInterface(){
        authorLabels.text = "by: \(photo.photoUserEmail)"
        datesLabel.text = "on: \(dateFormatter.string(from: photo.date))"
        captionTextField.text = photo.description
        if photo.documentID == "" {
            addBordersToEditableObjects()
        } else {
            if photo.photoUserID == Auth.auth().currentUser?.uid  {
                self.navigationItem.leftItemsSupplementBackButton = false
                saveButton.title = "Update"
                addBordersToEditableObjects()
                self.navigationController?.setToolbarHidden(false, animated: true)
            } else {
                saveButton.hide()
                cancelButton.hide()
                authorLabels.text = "Posted by: \(photo.photoUserEmail)"
                captionTextField.isEnabled = false
                captionTextField.backgroundColor = .white
            }
            
        }
        guard let url = URL(string: photo.photoURL) else {
            photoImage.image = photo.image
            return
        }
        photoImage.sd_imageTransition = .fade
        photoImage.sd_imageTransition?.duration = 0.5
        photoImage.sd_setImage(with: url)
    }
    
    func updateFromUserInterface(){
        photo.description = captionTextField.text!
        photo.image = photoImage.image!
    }
    
    
    func addBordersToEditableObjects(){
        captionTextField.addBorder(width: 0.5, radius: 5.0, color: .black)
        
    }
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        print("this will determine if the button is pressed")
        photo.saveData(restaurant : restaurant){ (success) in
            if success {
                self.leaveViewController()
            } else {
                print("Error: Can't unwind segue from PhotoViewController because of photo saving error.")
            }
        }
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        photo.deleteData(restaurant : restaurant){ (success) in
            if success {
                self.leaveViewController()
            } else{
                print("Delete unsuccessful")
            }
        }
    }

    
   
}
