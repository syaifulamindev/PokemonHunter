//
//  MyPokemonListCell.swift
//  PokemonHunter
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit
import Shuffle
import PokemonHunterKit
import PokemonHunterUI

public class MyPokemonListCell: UITableViewCell {
    //    var content: SwipeCard = SwipeCard()
    var content: UIView = .init()
    var pokemonImageView: CardContentView!
    var footer: CardFooterView!
    static let identifier = "MyPokemonListCell"
    public override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(content)
        
        
        content.isUserInteractionEnabled = false
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(content)
        content.anchor(top: safeAreaLayoutGuide.topAnchor,
                       left: safeAreaLayoutGuide.leftAnchor,
                       bottom: safeAreaLayoutGuide.bottomAnchor,
                       right: safeAreaLayoutGuide.rightAnchor,
        paddingTop: 8,
        paddingLeft: 16,
        paddingBottom: 8,
        paddingRight: 16)
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var pokemon: Pokemon!
    public func populate(_ pokemon: Pokemon) {
        self.pokemon = pokemon
        
        let urlString = "http://localhost:3000/sprites/pokemon/\(pokemon.id)"
        pokemonImageView = CardContentView(withUrlString: urlString)
        footer = CardFooterView(withTitle: "\(pokemon.name)", subtitle: urlString)
        content.addSubview(pokemonImageView)
        content.addSubview(footer)
        
        pokemonImageView.anchorToSuperview()
        footer.anchor(left: content.leftAnchor,
                      bottom: content.bottomAnchor,
                      right: content.rightAnchor,
                      height: 80)
    }
}
