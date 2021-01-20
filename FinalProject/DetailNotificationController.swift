//
//  DetailNotificationController.swift
//  FinalProject
//
//  Created by James Monahan on 12/11/20.
//

import UIKit

class DetailViewController: UIViewController {


    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var numberOfParticipants: UILabel!
    @IBOutlet weak var relativePrice: UILabel!
    
    var activityInfo: ActivityStruct!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if activityInfo == nil{
            activityInfo = ActivityStruct(activity: "", type: "", participants: 0, price: 0.0)
        }
        updateUserInterface()
       
    }
    
 
    func updateUserInterface() {
        activityLabel.text = activityInfo.activity
        typeLabel.text = activityInfo.type
        numberOfParticipants.text = String(activityInfo.participants)
        relativePrice.text = String(activityInfo.price)
     }

    

}
