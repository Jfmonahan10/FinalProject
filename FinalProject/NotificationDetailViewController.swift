//
//  NotificationDetailViewController.swift
//  FinalProject
//
//  Created by James Monahan
//

import UIKit

class NotificationDetailViewController: UIViewController {

    var activityInfo: ActivityStruct!
    var favorite: Favorite!
    var counter = 0
    @IBOutlet weak var typeLabels: UILabel!
    
    @IBOutlet weak var priceLabels: UILabel!
    @IBOutlet weak var activityLabels: UILabel!
    @IBOutlet weak var numberOfParticipantsLabels: UILabel!
    @IBOutlet weak var starButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if favorite == nil {
            favorite = Favorite()
        }
        if activityInfo == nil{
            activityInfo = ActivityStruct(activity: "", type: "", participants: 0, price: 0.0)
        }
        updateUserInterface()
       
    }
    
    
    @IBAction func starButtonPressed(_ sender: UIBarButtonItem) {
        if counter == 0{
            starButton.image = UIImage(systemName: "star.fill")
            counter = counter + 1
            favorite.name = activityLabels.text!
            favorite.saveData{ (success) in
                if success {
                    print("Well done")
                } else {
                    self.oneButtonAlert(title: "Save Failed", message: "For some reason, the data would not save to the cloud")
                }
            }
        } else{
            counter = 0
            starButton.image = UIImage(systemName: "star")
            favorite.name = activityLabels.text!
            favorite.deleteData{ (success) in
                if success {
                    print("Well done")
                } else {
                    self.oneButtonAlert(title: "Save Failed", message: "For some reason, the data would not save to the cloud")
                }
            }
        }
    }
    
    func updateUserInterface() {
        activityLabels.text = activityInfo.activity
        typeLabels?.text = activityInfo.type
        numberOfParticipantsLabels?.text = String(activityInfo.participants)
       priceLabels?.text = String(activityInfo.price)
     }
}
