//
//  UIView+Extension.swift
//  ios-code-challenge
//
//  Created by Kusum Miraj on 6/6/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation

extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = bounds.size
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
