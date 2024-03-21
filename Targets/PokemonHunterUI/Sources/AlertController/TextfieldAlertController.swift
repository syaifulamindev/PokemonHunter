//
//  TextfieldAlertController.swift
//  PokemonHunter
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit

class TextfieldAlertController: UIAlertController {
//    init(title: String?, message: String) {
//        super.init(nibName: nil, bundle: nil)
//        self.title = title
//        self.message = message
//    }
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func setup(placeholder: String, actionTitle: String, handler: @escaping (String?) -> Void) {
        addTextField { textfield in
            textfield.placeholder = placeholder
        }
        addAction(
            UIAlertAction(title: actionTitle, style: .default, handler: { [weak self] _ in
                handler(self?.textFields?.first?.text)
                self?.dismiss(animated: true)
            })
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
