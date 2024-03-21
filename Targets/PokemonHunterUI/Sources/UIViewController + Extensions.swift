//
//  UIViewController + Extensions.swift
//  PokemonHunterUI
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit

public extension UIViewController {
    func configureBackgroundGradient(gradientLayer: inout CAGradientLayer, view: UIView) {
        let background: UIColor = UIColor(red: 253 / 255, green: 255 / 255, blue: 226 / 255, alpha: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.colors = [UIColor.white.cgColor, background.cgColor]
    }
}
