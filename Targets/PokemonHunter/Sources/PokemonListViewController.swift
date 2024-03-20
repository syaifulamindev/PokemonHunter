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

class PokemonListViewController: UIViewController {
    let cardStack = SwipeCardStack()
    private let buttonStackView = UIStackView()
//    private var cancellables: Set<AnyCancellable> = .init()
    private var cancellables: [AnyCancellable] = []
    
    let button = UIButton(type: .system)
    let button2 = UIButton(type: .system)
    let button3 = UIButton(type: .system)
    let label = UILabel()
    
    let cardImages = [
        UIImage(systemName: "square.and.arrow.up") ?? .init(),
        UIImage(systemName: "eraser.line.dashed") ?? .init(),
        UIImage(systemName: "highlighter") ?? .init()
    ]
    
    let store: Store<PokemonList.State, PokemonList.Action>
    let viewStore: ViewStore<ViewState, ViewAction>
    var counter: Int = 0
    init(store: Store<PokemonList.State, PokemonList.Action>) {
        self.store = store
//        self.viewStore = ViewStore(
//          store,
//          observe: { $0 },
//          removeDuplicates: { $0 == $1 }
//        )
        self.viewStore = ViewStore(store.scope(state: { $0.view }, action: ViewAction.view), removeDuplicates: { viewState1, viewState2 in
            false
        })
        
        super.init(nibName: nil, bundle: nil)
        

    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureBackgroundGradient()
        layoutButtonStackView()
        layoutCardStackView()
        
        cardStack.dataSource = self
        cardStack.delegate = self
        
        
        
        let normalImageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .large)
        let largeImageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        
        
        if let image = UIImage(systemName: "arrow.uturn.backward.circle", withConfiguration: normalImageConfig), let fillImage = UIImage(systemName: "arrow.uturn.backward.circle.fill", withConfiguration: normalImageConfig) {
            button.setImage(image, for: .normal)
            button.setImage(fillImage, for: .highlighted)
        } else {
            button.setTitle("Undo", for: .normal)
        }
        button.addTarget(self, action: #selector(undo), for: .touchUpInside)
        
        if let image = UIImage(systemName: "target", withConfiguration: largeImageConfig) {
            button2.setImage(image, for: .normal)
        } else {
            button2.setTitle("Catch", for: .normal)
        }
        button2.addTarget(self, action: #selector(`catch`), for: .touchUpInside)
        
        if let image = UIImage(systemName: "chevron.right.circle", withConfiguration: normalImageConfig), let fillImage = UIImage(systemName: "chevron.right.circle.fill", withConfiguration: normalImageConfig) {
            button3.setImage(image, for: .normal)
            button3.setImage(fillImage, for: .highlighted)
        } else {
            button3.setTitle("Shift", for: .normal)
        }

        button3.addTarget(self, action: #selector(shift), for: .touchUpInside)
//        arrow.clockwise.icloud untuk reload
        
        buttonStackView.addArrangedSubview(button)
        buttonStackView.addArrangedSubview(button2)
        buttonStackView.addArrangedSubview(button3)
        
        
//        observe(\.store, changeHandler: { controller, kvoc in
//            kvoc.newValue.
//        })
        
        viewStore.publisher.pokemonList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
            guard let self = self else { return }
                self.counter += 1
                print("viewStorePublisher \(self.counter): \(list)")
        }
        .store(in: &cancellables)
        label.text = "test Label"
        view.addSubview(label)
        label.anchorToSuperview()
        
    }
    
    @objc func undo() {
        cardStack.undoLastSwipe(animated: true)
    }
    
    @objc func `catch`() {
//        store.send(.pokemonsResponse(["new pokemon from button"]))
        viewStore.send(.pokemonsResponse(.success(["`catch`"])))
    }
    
    @objc func shift() {
        cardStack.shift(animated: true)
    }
    
    func card(fromImage image: UIImage) -> SwipeCard {
        let card = SwipeCard()
        card.swipeDirections = [.left, .right]
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        card.content = imageView
        
        let leftOverlay = UIView()
        leftOverlay.backgroundColor = .gray
        
        let rightOverlay = UIView()
        rightOverlay.backgroundColor = .darkGray
        
        card.setOverlays([.left: leftOverlay, .right: rightOverlay])
        
        return card
    }
    
    private func configureBackgroundGradient() {
        let backgroundGray = UIColor(red: 244 / 255, green: 247 / 255, blue: 250 / 255, alpha: 1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, backgroundGray.cgColor]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
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
        return card(fromImage: cardImages[index])
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return cardImages.count
    }
}

extension PokemonListViewController: SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        viewStore.send(.pokemonsResponse(.success(["cardStack"])))
    }
}

extension PokemonListViewController {
    typealias ViewState = PokemonList.State
    typealias ViewAction = PokemonList.Action
}
