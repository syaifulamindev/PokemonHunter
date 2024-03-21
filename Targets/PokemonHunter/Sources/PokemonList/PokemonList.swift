//
//  PokemonList.swift
//  PokemonHunter
//
//  Created by saminos on 19/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit
import ComposableArchitecture
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
        
        @Published
        var pokemonDetailState: PokemonDetail.State?
        
        @Published
        var showRenameDialog: Bool = false
        var currentRenamedPokemon: Pokemon?
        
    }
    
    enum Action {
        
        case loadPokemons
        case pokemonsResponse(Result<[Pokemon], Error>)
        case isLoading(Bool)
        
        case catchPokemon(Pokemon)
        case catchPokemonResponse(Result<CatchPokemon, Error>)
        case showNicknameDialog(_ pokemon: Pokemon)
        case renamePokemon(_ pokemon: Pokemon?, nickname: String?)
        case renamePokemonResponse(_ renamePokemon: Result<RenamePokemon, Error>)
        
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
            case .catchPokemon(let pokemon):
                return .run { send in
                    await send(.isLoading(true))
                    await send(
                        .catchPokemonResponse(
                            await environment.pokemonService.catchPokemon(pokemon)
                                .map {
                                    var newPokemon = $0
                                    newPokemon.pokemon = pokemon
                                    return newPokemon
                                }
                        )
                    )
                }
            case .catchPokemonResponse(.success(let catchPokemon)):
                print("catchPokemon: \(catchPokemon)")
                guard catchPokemon.catch,
                      let pokemon = catchPokemon.pokemon else {
                    return .none
                }
                
                return .run { send in
                    await send(.showNicknameDialog(pokemon))
                }
            case .catchPokemonResponse(.failure(let error)):
                print(error.localizedDescription)
                return .none
            case .renamePokemon(let pokemon, let nickname):
                return .run { send in
                    await send(
                        .renamePokemonResponse(
                            await environment.pokemonService.renamePokemon(pokemon, nickname: nickname)
                        )
                    )
                }
            case .renamePokemonResponse(.success(let renamePokemon)):
                print("rename success, new name: \(renamePokemon)")
                return .none
            case .renamePokemonResponse(.failure(let error)):
                print(error.localizedDescription)
                return .none
            case .showNicknameDialog(let pokemon):
                //FIXME: DO SOMETHING HERE
                state.currentRenamedPokemon = pokemon
                state.showRenameDialog = true
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
