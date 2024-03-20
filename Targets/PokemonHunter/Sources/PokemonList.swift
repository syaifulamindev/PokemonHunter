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

let pokemonListReducer = Reducer<PokemonList.State, PokemonList.Action, PokemonList.Environment> { state, action, environment in
    switch action {
    case .isLoading(let loading):
        state.isLoading = loading
        return .none
    case .loadPokemons:
////        return .run { send in
////            await send(.isLoading(true))
//        var result: Effect<[String], Never>
//            do {
//                let pokemonList =
////                await send(.pokemonsResponse(pokemonList))
//                result = .init(value: pokemonList)
////                return PokemonList.Action.pokemonsResponse(pokemonList)
//            } catch let error {
////                await send(.pokemonsResponseFailure(error))
////                return PokemonList.Action.pokemonsResponseFailure(error)
//                result = .init(error: error)
//            }
//        return result.eras
////            await send(.isLoading(false))
////            state.
////        }
//        ///
        return PokemonService()
            .fetchPokemonList()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(PokemonList.Action.pokemonsResponse)
        
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

struct PokemonList {
    struct Environment {
        public var mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
        public var pokemonAPI: PokemonAPI = .init()
    }
    
    struct State: Equatable {
        var isLoading: Bool = false
        var pokemonList: [String] = []
    }
    
    enum Action {
        case `catch`
        case loadPokemons
        case pokemonsResponse(Result<[String], Error>)
        case isLoading(Bool)
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
