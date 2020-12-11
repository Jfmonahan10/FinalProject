//
//  PlacesViewController.swift
//  FinalProject
//
//  Created by James Monahan
//

import UIKit

class BostonCollegeViewController: UIViewController {

    @IBOutlet weak var transportationButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func getTicketsPressed(_ sender: UIButton) {
        if let appURL = URL(string: "https://bceagles.com/calendar") {
            UIApplication.shared.open(appURL) { success in
                if success {
                    print("The URL was delivered successfully.")
                } else {
                    print("The URL failed to open.")
                }
            }
        } else {
            print("Invalid URL specified.")
        }
    }
    
    @IBAction func concertButtonPressed(_ sender: UIButton) {
        if let appURL = URL(string: "https://www.bc.edu/content/bc-web/schools/mcas/departments/music/concert-calendar.html") {
            UIApplication.shared.open(appURL) { success in
                if success {
                    print("The URL was delivered successfully.")
                } else {
                    print("The URL failed to open.")
                }
            }
        } else {
            print("Invalid URL specified.")
        }
    }
    @IBAction func musicalButtonPressed(_ sender: UIButton) {
        if let appURL = URL(string: "https://www.bc.edu/bc-web/schools/mcas/departments/theatre/about/the-performance-and-production-program/current-season.html") {
            UIApplication.shared.open(appURL) { success in
                if success {
                    print("The URL was delivered successfully.")
                } else {
                    print("The URL failed to open.")
                }
            }
        } else {
            print("Invalid URL specified.")
        }
    }
    
    @IBAction func clubButtonPressed(_ sender: UIButton) {
        if let appURL = URL(string: "https://www.bc.edu/bc-web/campus-life/student-organizations.html") {
            UIApplication.shared.open(appURL) { success in
                if success {
                    print("The URL was delivered successfully.")
                } else {
                    print("The URL failed to open.")
                }
            }
        } else {
            print("Invalid URL specified.")
        }
    }
    
    @IBAction func newsButtonPressed(_ sender: UIButton) {
        if let appURL = URL(string: "https://www.bcheights.com/") {
            UIApplication.shared.open(appURL) { success in
                if success {
                    print("The URL was delivered successfully.")
                } else {
                    print("The URL failed to open.")
                }
            }
        } else {
            print("Invalid URL specified.")
        }
    }
    @IBAction func exerciseButtonPressed(_ sender: UIButton) {
        if let appURL = URL(string: "https://www.bc.edu/content/bc-web/offices/rec/fitness.html") {
            UIApplication.shared.open(appURL) { success in
                if success {
                    print("The URL was delivered successfully.")
                } else {
                    print("The URL failed to open.")
                }
            }
        } else {
            print("Invalid URL specified.")
        }
    }
    @IBAction func leaderButtonPressed(_ sender: UIButton) {
        if let appURL = URL(string: "https://www.bc.edu/content/bc-web/offices/auxiliary-services/sites/event-management/bc-community/reserve-a-space") {
            UIApplication.shared.open(appURL) { success in
                if success {
                    print("The URL was delivered successfully.")
                } else {
                    print("The URL failed to open.")
                }
            }
        } else {
            print("Invalid URL specified.")
        }
    }
    
    @IBAction func transportationButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let redLine = UIAlertAction(title: "Red T Line", style: .default) { (_) in
            self.transportationButton.setTitle("Red T Line", for: .normal)
            self.changeInterface(tLine: "Red")
        }
        let organeLine = UIAlertAction(title: "Organe T Line", style: .default) { (_) in
            self.transportationButton.setTitle("Organe T Line", for: .normal)
            self.changeInterface(tLine: "Orange")
        }
        let blueLine = UIAlertAction(title: "Blue Line", style: .default) { (_) in
            self.transportationButton.setTitle("Blue Line", for: .normal)
            self.changeInterface(tLine: "Blue")
        }
        let mattapanTrolley = UIAlertAction(title: "Matappan Trolley", style: .default) { (_) in
            self.transportationButton.setTitle("Matapan Trolley", for: .normal)
            self.changeInterface(tLine: "Mattapan")
        }
        let greenLine = UIAlertAction(title: "Green Line", style: .default) { (_) in
            self.transportationButton.setTitle("Green Line", for: .normal)
            self.changeInterface(tLine: "Green")
        }
        let greenLineB = UIAlertAction(title: "Green Line B(Boston College)", style: .default) { (_) in
            self.transportationButton.setTitle("Green Line B", for: .normal)
            self.changeInterface(tLine: "Green-B")
        }
        let greenLineC = UIAlertAction(title: "Green Line C", style: .default) { (_) in
            self.transportationButton.setTitle("Green Line C", for: .normal)
            self.changeInterface(tLine: "Green-C")
        }
        let greenLineD = UIAlertAction(title: "Green Line D", style: .default) { (_) in
            self.transportationButton.setTitle("Green Line D", for: .normal)
            self.changeInterface(tLine: "Green-D")
        }
        let greenLineE = UIAlertAction(title: "Green Line E", style: .default) { (_) in
            self.transportationButton.setTitle("Green Line E", for: .normal)
            self.changeInterface(tLine: "Green-E")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
        alertController.addAction(redLine)
        alertController.addAction(organeLine)
        alertController.addAction(blueLine)
        alertController.addAction(mattapanTrolley)
        alertController.addAction(greenLine)
        alertController.addAction(greenLineB)
        alertController.addAction(greenLineC)
        alertController.addAction(greenLineD)
        alertController.addAction(greenLineE)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func changeInterface(tLine: String){
        if let appURL = URL(string: "https://www.mbta.com/schedules/\(tLine)/schedule") {
            UIApplication.shared.open(appURL) { success in
                if success {
                    print("The URL was delivered successfully.")
                } else {
                    print("The URL failed to open.")
                }
            }
        } else {
            print("Invalid URL specified.")
        }
    }
    
}
