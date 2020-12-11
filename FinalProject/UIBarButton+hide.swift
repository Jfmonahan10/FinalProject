//
//  UIBarButton+hide.swift
//  SnacktacularThree
//
//  Created by James Monahan
//

import UIKit

extension UIBarButtonItem{
    func hide(){
        self.isEnabled = false
        self.tintColor = .clear
    }
}
