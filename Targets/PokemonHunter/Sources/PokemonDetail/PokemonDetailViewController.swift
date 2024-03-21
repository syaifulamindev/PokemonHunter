//
//  PokemonDetailViewController.swift
//  PokemonHunter
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit
import PokemonHunterUI

class PokemonDetailViewController: UIViewController {
    let pokemonImageView: UIImageView = UIImageView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pokemonImageView)
        pokemonImageView.backgroundColor = .white
        pokemonImageView.contentMode = .scaleAspectFit
        pokemonImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                paddingTop: 0,
                                width: 100,
                                height: 100)
        pokemonImageView.round(50)
        pokemonImageView.anchor(view.centerXAnchor)
        pokemonImageView.load(url: URL(string: "http://localhost:3000/sprites/pokemon/3")!)
    }
    
}
