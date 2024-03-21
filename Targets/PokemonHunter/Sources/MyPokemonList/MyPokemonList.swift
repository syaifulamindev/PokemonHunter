//
//  MyPokemonList.swift
//  PokemonHunter
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit
import ComposableArchitecture
import PokemonHunterKit
import PokemonAPI


extension MyPokemonList.State: Hashable {
    static func == (lhs: MyPokemonList.State, rhs: MyPokemonList.State) -> Bool {
//        lhs.isLoading == rhs.isLoading &&
        lhs.pokemonList == rhs.pokemonList &&
        lhs.showRenameDialog == rhs.showRenameDialog
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(pokemonList)
        hasher.combine(showRenameDialog)
    }
}

struct MyPokemonList: Reducer {
    
    struct Environment {
        public var pokemonService: PokemonHunterKit.PokemonService = .init()
    }
    
    class State {
        @Published
        var pokemonList: [Pokemon] = SharedMyPokemonListData.shared.myPokemons
        
        @Published
        var showRenameDialog: Bool = false
    }
    
    enum Action {
        case isLoading(Bool)
        
        case catchPokemon(Pokemon)
        case catchPokemonResponse(Result<CatchPokemon, Error>)
        case showNicknameDialog(_ pokemon: Pokemon)
        case renamePokemon(_ pokemon: Pokemon?, nickname: String?)
        case renamePokemonResponse(_ renamePokemon: Result<RenamePokemon, Error>)
        
        case releasePokemon(Pokemon)
        
    }
    
    var environment: Environment = .init()
    var body: some ReducerOf<MyPokemonList> {
        Reduce { state, action in
            switch action {
                
            case .isLoading(let loading):
                print("isLoading: \(loading)")
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
            case .showNicknameDialog:
                //FIXME: DO SOMETHING HERE
                state.showRenameDialog = true
                return .none
                
            case .releasePokemon(_):
                //FIXME: RELEASE POKEMON!
                break;
            }
            return .none
        }
    }
}
