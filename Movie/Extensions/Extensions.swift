//
//  RingProgressView.swift
//  Movie
//
//  Created by Bekzod Rakhmatov on 08/12/2018.
//  Copyright © 2018 Bekzod Rakhmatov. All rights reserved.
//

import UIKit
import MKRingProgressView

extension RingProgressView {
    func animateTo(_ number: Int) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        self.progress = Double(number)/100
        CATransaction.commit()
    }
}

extension UIView {
    
    @IBInspectable var shadowOffsetY: CGFloat {
        
        set {
            layer.shadowOffset.height = newValue
        }
        
        get {
            return layer.shadowOffset.height
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        
        get {
            return layer.shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: CGFloat {
        set {
            layer.shadowOpacity = Float(newValue)
        }
        get {
            return CGFloat(layer.shadowOpacity)
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        set {
            layer.shadowColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
    }
}
