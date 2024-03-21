//
//  PokemonListViewController.swift
//  PokemonHunter
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit
import ComposableArchitecture
import Shuffle
import Combine
import PokemonHunterUI
import PokemonHunterKit

class PokemonListViewController: UIViewController {
    let cardStack = SwipeCardStack()
    private let buttonStackView = UIStackView()
//    private var cancellables: Set<AnyCancellable> = .init()
    private var cancellables: [AnyCancellable] = []
    
    lazy var undoButton: UIButton = {
        button("Undo", imageName: "arrow.uturn.backward.circle", hintImageName: "arrow.uturn.backward.circle.fill", selector: #selector(undo))
    }()
    
    lazy var catchButton: UIButton = {
        button("Catch", imageName: "target", selector: #selector(`catch`), config: largeImageConfig)
    }()
    
    lazy var shiftButton: UIButton = {
        button("Shift", imageName: "chevron.right.circle", hintImageName: "chevron.right.circle.fill", selector: #selector(shift))
    }()
    
    lazy var loadButton: UIButton = {
        button("Load", imageName: "arrow.clockwise.icloud", hintImageName: "arrow.clockwise.icloud.fill", selector: #selector(fetchNext))
    }()
    
    lazy var favoriteButton: UIButton = {
        button("Favorite", imageName: "star.circle", hintImageName: "star.circle.fill", selector: #selector(favorite))
    }()
    
    let store: Store<PokemonList.State, PokemonList.Action>
    let viewStore: ViewStore<ViewState, ViewAction>
    
    init(store: Store<PokemonList.State, PokemonList.Action>) {
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
    
    let largeImageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        configureBackgroundGradient()
        layoutButtonStackView()
        layoutCardStackView()
        
        cardStack.dataSource = self
        cardStack.delegate = self
        
        buttonStackView.addArrangedSubview(undoButton)
        buttonStackView.addArrangedSubview(favoriteButton)
        buttonStackView.addArrangedSubview(catchButton)
        buttonStackView.addArrangedSubview(loadButton)
        buttonStackView.addArrangedSubview(shiftButton)
        
       
        viewStore.$isLoading.sink { isLoading in
            print("$isLoading: \(isLoading)")
        }
        .store(in: &cancellables)
        
        viewStore.$pokemonList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
            guard let self else { return }
            
            self.cardStack.reloadData()
        }
        .store(in: &cancellables)
        
        store.send(.loadPokemons)
        
    }
    
    var gradientLayer: CAGradientLayer = .init()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureBackgroundGradient(gradientLayer: &gradientLayer, view: view)
    }
    
    func button(_ hintTitle: String, imageName: String, hintImageName: String? = nil, selector: Selector, config: UIImage.SymbolConfiguration = .init(pointSize: 16, weight: .bold, scale: .large)) -> UIButton {
        let button: UIButton = .init(type: .system)
        
        if let image = UIImage(systemName: imageName, withConfiguration: config), let fillImage = UIImage(systemName: hintImageName ?? imageName, withConfiguration: config) {
            button.setImage(image, for: .normal)
            button.setImage(fillImage, for: .highlighted)
        } else {
            button.setTitle("Undo", for: .normal)
        }
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    @objc func undo() {
        cardStack.undoLastSwipe(animated: true)
    }
    
    @objc func `catch`() {

    }
    
    @objc func shift() {
        cardStack.shift(animated: true)
    }
    
    @objc func fetchNext() {
        store.send(.loadPokemons)
    }
    
    @objc func favorite() {
        print("favorite")
    }

    func card(_ pokemon: Pokemon) -> SwipeCard {
        let card = SwipeCard()
        card.footerHeight = 80
        card.swipeDirections = [.left, .up, .right]
        for direction in card.swipeDirections {
          card.setOverlay(CardOverlay(direction: direction), forDirection: direction)
        }
        let urlString = "http://localhost:3000/sprites/pokemon/\(pokemon.id)"
        card.content = CardContentView(withUrlString: urlString)
        card.footer = CardFooterView(withTitle: "\(pokemon.name)", subtitle: urlString)

        return card
    }
    
    private func layoutCardStackView() {
        view.addSubview(cardStack)
        cardStack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         bottom: buttonStackView.topAnchor,
                         right: view.safeAreaLayoutGuide.rightAnchor)
    }
    
    private func layoutButtonStackView() {
        view.addSubview(buttonStackView)
        buttonStackView.distribution = .equalSpacing
        buttonStackView.alignment = .center
        buttonStackView.anchor(left: view.safeAreaLayoutGuide.leftAnchor,
                               bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               right: view.safeAreaLayoutGuide.rightAnchor,
                               paddingLeft: 24,
                               paddingBottom: 12,
                               paddingRight: 24)
    }
}

extension PokemonListViewController: SwipeCardStackDataSource {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        return card(viewStore.pokemonList[index])
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return viewStore.pokemonList.count
    }
}

extension PokemonListViewController: SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        
    }
}

extension PokemonListViewController {
    typealias ViewState = PokemonList.State
    typealias ViewAction = PokemonList.Action
}
