//
//  InformationViewController.swift
//  FinalProject
//
//  Created by James Monahan on 1/19/21.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var personalImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var relationshipStatus: UILabel!
    @IBOutlet weak var genderStatus: UILabel!
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var firstSpotLabel: UILabel!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var secondSpotLabel: UILabel!
    @IBOutlet var thirdSpotLabel: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func firstScreen (){
        if friendButton.titleLabel?.text == "Friend This Person" || friendButton.titleLabel?.text == "Requested" {
            self.relationshipStatus.isHidden = true
            self.genderStatus.isHidden = true
            self.firstSpotLabel.isHidden = true
            self.secondSpotLabel.isHidden = true
            self.thirdSpotLabel.isHidden = true
        }
    }
    
    @IBAction func friendButtonPressed(_ sender: UIButton) {
        if friendButton.titleLabel?.text == "Friend This Person"{
            friendButton.titleLabel?.text = "Requested"
            
            
        } else if friendButton.titleLabel?.text == "Requested" || friendButton.titleLabel?.text == "Friend" {
            friendButton.titleLabel?.text = "Friend This Person"
            firstScreen()
        }
    }
    
}
