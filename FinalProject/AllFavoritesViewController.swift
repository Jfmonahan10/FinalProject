//
//  AllFavoritesViewController.swift
//  FinalProject
//
//  Created by James Monahan 
//

import UIKit

class AllFavoritesViewController: UIViewController {
    

    var favorites: Favorites!
    var favorite: Favorite!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var favoriteTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        favorites = Favorites()
        favorite = Favorite()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
     
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
        favorites.loadData {
            self.favoriteTableView.reloadData()
        }
    }
    @IBAction func signOut(_ sender: UIButton) {

    }
    

    
    @IBAction func segmentButtonPressed(_ sender: UISegmentedControl) {
        switch segmentController.selectedSegmentIndex{
        case 1:
            performSegue(withIdentifier: "PlanSegue", sender: nil)
            segmentController.selectedSegmentIndex = 0
        case 2:
            performSegue(withIdentifier: "PrivateEventsSegue", sender: nil)
            segmentController.selectedSegmentIndex = 0
        case 3:
            performSegue(withIdentifier: "NotificationsSegue", sender: nil)
            segmentController.selectedSegmentIndex = 0
        case 4:
            performSegue(withIdentifier: "SearchsSegue", sender: nil)
            segmentController.selectedSegmentIndex = 0
        case 5:
            performSegue(withIdentifier: "ProfileSegue", sender: nil)
            segmentController.selectedSegmentIndex = 0
        default:
            return
        }
        favoriteTableView.reloadData()
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if favoriteTableView.isEditing {
            favoriteTableView.setEditing(false, animated: true)
            sender.title = "Edit"
            
        } else {
            favoriteTableView.setEditing(true, animated: true)
            sender.title = "Done"
        }
    }
    

}

extension AllFavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.favoriteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        self.favoriteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) 
        
        cell.textLabel?.text = favorites.favoriteArray[indexPath.row].name
        print("This is the name of the cell" +  favorites.favoriteArray[indexPath.row].name )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = favorites.favoriteArray[sourceIndexPath.row]
        favorites.favoriteArray.remove(at: sourceIndexPath.row)
        favorites.favoriteArray.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favorite.documentID = favorites.favoriteArray[indexPath.row].documentID
            favorites.favoriteArray.remove(at: indexPath.row )
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            print("look here" + favorite.name)
            favorite.deleteData{ (success) in
                if success {
                    print("Well done")
                } else {
                    self.oneButtonAlert(title: "Save Failed", message: "For some reason, the data would not save to the cloud")
                }
            }
        }
        favoriteTableView.reloadData()
    
    }
    
    
}
