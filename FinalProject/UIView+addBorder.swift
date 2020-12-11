//
//  UIView+addBorder.swift
//  SnacktacularThree
//
//  Created by James Monahan
//

import UIKit

extension UIView{
    func addBorder(width: CGFloat, radius: CGFloat, color: UIColor){
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
    }
    
    func noBorder(){
        self.layer.borderWidth = 0.0
    }
}
