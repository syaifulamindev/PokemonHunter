//
//  ButtonStackView.swift
//  PokemonHunterUI
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit

public extension ButtonStackView.Button {
    
    static func make(_ target: Any?, title: String, systemImage: SystemImage, style: ButtonStackView.ImageSymbolStyle = .normal, selector: Selector) -> ButtonStackView.Button {
        let button = self.make(target, hintTitle: title, imageName: systemImage.rawValue, selector: selector, config: style.config)
        button.setTitle(title, for: .normal)
        return button
    }
    
    static func make(_ target: Any?, hint: String, systemImage: SystemImage, style: ButtonStackView.ImageSymbolStyle = .normal, selector: Selector) -> ButtonStackView.Button {
        self.make(target, hintTitle: hint, imageName: systemImage.rawValue, selector: selector, config: style.config)
    }
    
    static func make(_ target: Any?, hintTitle: String, imageName: String, hintImageName: String? = nil, selector: Selector, config: UIImage.SymbolConfiguration = .init(pointSize: 16, weight: .bold, scale: .large)) -> ButtonStackView.Button {
        let button: UIButton = .init(type: .system)

        if let image = UIImage(systemName: imageName, withConfiguration: config), let fillImage = UIImage(systemName: hintImageName ?? imageName, withConfiguration: config) {
            button.setImage(image, for: .normal)
            button.setImage(fillImage, for: .highlighted)
        } else {
            button.setTitle(hintTitle, for: .normal)
        }
        button.addTarget(target, action: selector, for: .touchUpInside)
        return button
    }
}

public class ButtonStackView: UIStackView {
    public typealias Button = UIButton
    
    public enum ImageSymbolStyle {
        case normal, large
        
        var config: UIImage.SymbolConfiguration {
            switch self {
            case .normal:
                return .init(pointSize: 16, weight: .bold, scale: .large)
            case .large:
                return .init(pointSize: 22, weight: .bold, scale: .large)
            }
        }
    }
    
    init(items: [ButtonStackView.Button]) {
        super.init(frame: .zero)
        self.add { items }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func add(_ item: ButtonStackView.Button) {
        addArrangedSubview(item)
    }
    
    public func add(_ items: () -> [ButtonStackView.Button]) {
        items().forEach { add($0) }
    }
    
    
}
