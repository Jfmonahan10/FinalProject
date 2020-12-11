//
//  UIViewController+alert.swift
//  ToDoListApp
//
//  Created by James Monahan
//  Copyright © 2020 James Monahan. All rights reserved.
//

import UIKit

extension UIViewController {
    func oneButtonAlert (title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
    
