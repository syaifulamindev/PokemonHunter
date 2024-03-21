//
//  PokemonDetailViewController.swift
//  PokemonHunter
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit
import PokemonHunterUI
import Combine
import ComposableArchitecture

class PokemonDetailViewController: UIViewController {
    private var cancellables: [AnyCancellable] = []
    let store: StoreOf<PokemonDetail>
    let viewStore: ViewStore<ViewState, ViewAction>
    
    let pokemonImageView: UIImageView = UIImageView(frame: .zero)
    let pokemonNameView: CardOverlayLabelView
    let informationTableView: InformationTableView = .init(frame: .zero)
    
    lazy var catchButton: UIButton = {
        let button: UIButton = .make(self, title: "Catch", systemImage: SystemImage.catch, style: .large, selector: #selector(`catch`))
        button.shadow()
        return button
    }()

    init(store: StoreOf<PokemonDetail>) {
        self.store = store
        self.viewStore = ViewStore(
          store,
          observe: { $0 },
          removeDuplicates: { $0 == $1 }
        )
        
        self.pokemonNameView = .init(withTitle: viewStore.pokemon.name, color: .sampleGreen, rotation: 0)
        
        super.init(nibName: nil, bundle: nil)
        
        if let pokemonImage = viewStore.pokemonImage {
            pokemonImageView.image = pokemonImage
        } else {
            // blob image if needed
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pokemonImageView)
        view.addSubview(pokemonNameView)
        view.addSubview(informationTableView)
        view.addSubview(catchButton)
        
        pokemonImageView.backgroundColor = .white
        pokemonImageView.contentMode = .scaleAspectFit
        pokemonImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                paddingTop: 16,
                                width: 100,
                                height: 100)
        pokemonImageView.round(50)
        pokemonImageView.shadow()
        pokemonImageView.anchor(view.centerXAnchor)
        
        pokemonNameView.anchor(top: pokemonImageView.bottomAnchor, paddingTop: 16)
        pokemonNameView.anchor(view.centerXAnchor)
        
        
        informationTableView.anchor(
            top: pokemonNameView.bottomAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor,
            paddingTop: 16
        )
        
        
        catchButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        catchButton.anchor(view.centerXAnchor)
        viewStore.$pokemonDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
            guard let self else { return }
                self.populatePokemonDetail()
        }
        .store(in: &cancellables)
        
        viewStore.send(.loadPokemonDetail(viewStore.pokemon))
    }
    
    @objc
    func `catch`() {
        print("catch")
    }
    
    func populatePokemonDetail() {
        if viewStore.pokemonImage == nil, let url = URL(string: "http://localhost:3000/sprites/pokemon/\(viewStore.pokemon.id)") {
            pokemonImageView.load(url: url)
        }
        guard let pokemonDetail = viewStore.pokemonDetail else { return }
        let informations = pokemonDetail.moves?.compactMap {
            Information(text: $0.move?.name, secondaryText: nil)
        }
        informationTableView.update(informations, title: "Moves")
    }
    
    var gradientLayer: CAGradientLayer = .init()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureBackgroundGradient(gradientLayer: &gradientLayer, view: view)
    }
    
    
}

extension PokemonDetailViewController {
    typealias ViewState = PokemonDetail.State
    typealias ViewAction = PokemonDetail.Action
}
