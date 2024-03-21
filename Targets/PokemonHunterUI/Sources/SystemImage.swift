//
//  SystemImageName.swift
//  PokemonHunterUI
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit

public enum SystemImage: String {
    case undo = "arrow.uturn.backward.circle"
    case undoFill = "arrow.uturn.backward.circle.fill"
    case `catch` = "target"
    case shift = "chevron.right.circle"
    case shiftFill = "chevron.right.circle.fill"
    case load = "arrow.clockwise.icloud"
    case loadFill = "arrow.clockwise.icloud.fill"
    case favorite = "star.circle"
    case favoriteFill = "star.circle.fill"
    
    var image: UIImage? {
        UIImage(systemName: rawValue)
    }
    
}
