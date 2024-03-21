//
//  UIView + Extensions.swift
//  PokemonHunterUI
//
//  Created by saminos on 20/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit

// MARK: Layout
public extension UIView {
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat = 0,
                height: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: paddingTop))
        }
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: paddingLeft))
        }
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom))
        }
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -paddingRight))
        }
        if width > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: width))
        }
        if height > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: height))
        }
        
        anchors.forEach { $0.isActive = true }
        
        return anchors
    }
    
    @discardableResult
    func anchor(_ centerX:NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let anchor = centerXAnchor.constraint(equalTo: centerX, constant: constant)
        anchor.isActive = true
        return anchor
    }
    
    @discardableResult
    func anchor(_ centerY:NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let anchor = centerYAnchor.constraint(equalTo: centerY, constant: constant)
        anchor.isActive = true
        return anchor
    }
    
    @discardableResult
    func anchorToSuperview() -> [NSLayoutConstraint] {
        return anchor(top: superview?.topAnchor,
                      left: superview?.leftAnchor,
                      bottom: superview?.bottomAnchor,
                      right: superview?.rightAnchor)
    }
}

// MARK: Shadow
public extension UIView {
    
    
    func shadow(radius: CGFloat = 8,
                opacity: Float = 0.2,
                offset: CGSize = CGSize(width: 0, height: 2),
                color: UIColor = .black) {
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
    }
    
}

// MARK: Radius
public extension UIView {
    func round(_ radius: CGFloat) {
        layer.cornerRadius = radius
    }
}
