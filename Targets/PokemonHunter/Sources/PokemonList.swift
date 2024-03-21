//
//  PokemonList.swift
//  PokemonHunter
//
//  Created by saminos on 19/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit
import ComposableArchitecture
import PokemonAPI
import PokemonHunterKit
extension PokemonList.State: Hashable {
    static func == (lhs: PokemonList.State, rhs: PokemonList.State) -> Bool {
        lhs.isLoading == rhs.isLoading &&
        lhs.pokemonList == rhs.pokemonList
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(isLoading)
        hasher.combine(pokemonList)
    }
}


struct PokemonList: Reducer {
    struct Environment {
        public var mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
        public var pokemonService: PokemonHunterKit.PokemonService = .init()
    }
    
    class State {
        
        @Published
        var isLoading: Bool = false
        
        @Published
        var pokemonList: [Pokemon] = []
        
        
    }
    
    enum Action {
        case `catch`
        case loadPokemons
        case pokemonsResponse(Result<[Pokemon], Error>)
        case isLoading(Bool)
    }
    
    var environment: Environment = .init()
    var body: some ReducerOf<PokemonList> {
        Reduce { state, action in
            switch action {
            case .isLoading(let loading):
                state.isLoading = loading
                return .none
            case .loadPokemons:
                return .run { send in
                    await send(.isLoading(true))
                    await send(
                        .pokemonsResponse(
                            await environment.pokemonService.fetchPokemonList()
                        )
                    )
                    await send(.isLoading(false))
        
                }
            case .pokemonsResponse(let response):
                switch response {
                case .success(let pokemonList):
                    state.pokemonList = pokemonList
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                return .none
            case .catch:
                return .none
            }
        }
    }
}

extension PokemonList.State {
    var view: PokemonListViewController.ViewState {
        self
    }
}

extension PokemonList.Action {
//    var view: PokemonListViewController.ViewAction {
//        self
//    }
    static func view(_ localAction: PokemonListViewController.ViewAction) -> Self {
        localAction
    }
}
