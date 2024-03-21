//
//  SharedMyPokemonListData.swift
//  PokemonHunter
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import Foundation
import PokemonHunterKit

class SharedMyPokemonListData {
    static var shared: SharedMyPokemonListData = .init()
    private init() {}
    
    var myPokemons: [Pokemon] = []
}
