//
//  NotificationViewController.swift
//  FinalProject
//
//  Created by James Monahan
//

import UIKit

class NotificationViewController: UIViewController {

    var activity = Activity()
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        for _ in 1...20{
            activity.getData{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                    }
                }
        }
        
    }
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "ShowDetail" {
               let destination = segue.destination as! NotificationDetailViewController
               let selectedIndexPath = tableView.indexPathForSelectedRow!
               destination.activityInfo = activity.activityArray[selectedIndexPath.row]
           }
       }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activity.activityArray.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = " \(activity.activityArray[indexPath.row].activity)"
        return cell
    }
    
}
