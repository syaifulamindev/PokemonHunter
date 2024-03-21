//
//  InformationTableView.swift
//  PokemonHunterUI
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit

public struct Information {
    let text: String?
    let secondaryText: String?
    public init(text: String?, secondaryText: String?) {
        self.text = text
        self.secondaryText = secondaryText
    }
}

public class InformationTableView: UITableView {
    
    var didSelectRowAtIndex: ((Int) -> Void)?
    var informations: [Information] = [] {
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
        register(UITableViewCell.self, forCellReuseIdentifier: identifier)
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
    
    public func update(_ informations: [Information]?, title: String? = nil) {
        self.informations = informations ?? []
        self.title = title
        
    }
    
    public func config(accessoryType: UITableViewCell.AccessoryType = .none, selectable: Bool = false, separatorStyle: UITableViewCell.SeparatorStyle = .none) {
        self.accessoryType = accessoryType
        self.allowsSelection = selectable
        self.separatorStyle = separatorStyle
    }
    
//    tableview
        
}

extension InformationTableView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        title
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return informations.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.accessoryType = accessoryType
        cell.backgroundView = .init(frame: .zero)
        cell.backgroundColor = nil
        
        let information = informations[indexPath.row]
        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            config.text = information.text
            config.secondaryText = information.secondaryText
            
            //            config.textProperties.font = UIFont.systemFont(ofSize: 14)
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.text = information.text
            cell.detailTextLabel?.text = information.secondaryText
//            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        return cell
    }
}

extension InformationTableView: UITableViewDelegate {
 
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAtIndex?(indexPath.row)
    }
    
}
