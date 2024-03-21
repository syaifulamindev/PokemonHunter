//
//  MyPokemonTableView.swift
//  PokemonHunter
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit
import PokemonHunterKit

public struct MyPokemon {
    let text: String?
    let secondaryText: String?
    public init(text: String?, secondaryText: String?) {
        self.text = text
        self.secondaryText = secondaryText
    }
}

public class MyPokemonTableView: UITableView {
    
    var didSelectRowAtIndex: ((Int) -> Void)?
    var data: [Pokemon] = [] {
        didSet {
            reloadData()
        }
    }
    
    var title: String?
    
    var accessoryType: UITableViewCell.AccessoryType = .none
    var identifier: String {
        Self.description()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(MyPokemonListCell.self, forCellReuseIdentifier: MyPokemonListCell.identifier)
        dataSource = self
        delegate = self
        allowsSelection = false
        separatorStyle = .none
        backgroundView = nil
        backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(_ pokemons: [Pokemon]?, title: String? = nil) {
        self.data = pokemons ?? []
        self.title = title
        
    }
    
    public func config(accessoryType: UITableViewCell.AccessoryType = .none, selectable: Bool = false, separatorStyle: UITableViewCell.SeparatorStyle = .none) {
        self.accessoryType = accessoryType
        self.allowsSelection = selectable
        self.separatorStyle = separatorStyle
    }
    
//    tableview
        
}

extension MyPokemonTableView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        title
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: MyPokemonListCell.identifier, for: indexPath) as? MyPokemonListCell else { return .init()}
        
        cell.backgroundView = .init(frame: .zero)
        cell.backgroundColor = nil
        cell.populate(data[indexPath.row])
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIScreen.main.bounds.height * 0.3
    }
}

extension MyPokemonTableView: UITableViewDelegate {
 
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAtIndex?(indexPath.row)
    }
    
}
