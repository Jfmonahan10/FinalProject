//
//  PrivateViewController.swift
//  FinalProject
//
//  Created by James Monahan on 1/19/21.
//

import UIKit
import Foundation
import Firebase    

class PrivateViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate{

    
    @IBOutlet weak var privateTableView: UITableView!
    var privateArray: [String] = []
    var db = Firestore.firestore()
    
    var searchController: UISearchController!
    
    var dataArray = [String]()
     
    var filteredArray = [String]()
     
    var shouldShowSearchResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        privateTableView.delegate = self
        privateTableView.dataSource = self
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
        loadData {
            self.privateTableView.reloadData()
        }
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
                print("This ain't working chief")
                return completed()
            }
            self.privateArray = []
            for document in querySnapshot!.documents {
                let profileUser = ProfileUser(dictionary: document.data())
                profileUser.documentID = document.documentID
                self.privateArray.append(profileUser.email)
            }
            completed()
        }
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        privateTableView.tableHeaderView = searchController.searchBar
        self.searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        privateTableView.reloadData()
        print("senders send")
    }
     
     
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        privateTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            privateTableView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        filteredArray = privateArray.filter { $0.localizedCaseInsensitiveContains(searchString ?? "") }
        privateTableView.reloadData()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowInformation" {
//            let destination = segue.destination as! InformationViewController
//            let selectedIndexPath = privateTableView.indexPathForSelectedRow!
//            destination.nameLabel.text = filteredArray[selectedIndexPath]
//        }
//    }
    
    
}

extension PrivateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
                return filteredArray.count
        }else {
            return privateArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateCell", for: indexPath)
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredArray[indexPath.row]
        } else {
            cell.textLabel?.text = privateArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

