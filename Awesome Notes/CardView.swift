//
//  CardView.swift
//  Awesome Notes
//
//  Created by Abdul-Mujib Aliu on 5/8/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import Foundation


import UIKit

@IBDesignable
class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 2
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 2
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 1
        layer.borderColor = SHADOW_COLOR.cgColor
    }
    
}
