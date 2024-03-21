//
//  MyPokemonListViewController.swift
//  PokemonHunter
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit
import PokemonHunterUI
import Combine
import ComposableArchitecture

class MyPokemonListViewController: UIViewController {
    private var cancellables: [AnyCancellable] = []
    let store: StoreOf<MyPokemonList>
    let viewStore: ViewStore<ViewState, ViewAction>
    
    
    let mypokemonsTableView: MyPokemonTableView = .init(frame: .zero)

    init(store: StoreOf<MyPokemonList>) {
        self.store = store
        self.viewStore = ViewStore(
          store,
          observe: { $0 },
          removeDuplicates: { $0 == $1 }
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mypokemonsTableView)

        mypokemonsTableView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            paddingTop: 16
        )
        
        viewStore.$pokemonList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
            guard let self else { return }
                self.mypokemonsTableView.update(list)
        }
        .store(in: &cancellables)
        
        viewStore.$showRenameDialog
            .sink { [weak self] show in
                guard show else { return }
                let controller = TextfieldAlertController(title: "Rename", message: "update your pokemon name", preferredStyle: .alert)
                controller.setup(placeholder: "Pockemon Nickname", actionTitle: "OK") { [weak self] newNickname in
                    guard let self else { return }
                    //FIXME: RENAME
//                    self.store.send(.renamePokemon(self.viewStore.state.pokemon, nickname: newNickname))
                }
                self?.navigationController?.present(controller, animated: true)
            }.store(in: &cancellables)
    }
    
    var gradientLayer: CAGradientLayer = .init()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureBackgroundGradient(gradientLayer: &gradientLayer, view: view)
    }
    
    
}

extension MyPokemonListViewController {
    typealias ViewState = MyPokemonList.State
    typealias ViewAction = MyPokemonList.Action
}
