//
//  PokemonDetail.swift
//  PokemonHunterUI
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import UIKit
import ComposableArchitecture
import PokemonHunterKit
import PokemonAPI

extension PokemonDetail.State: Hashable {
    static func == (lhs: PokemonDetail.State, rhs: PokemonDetail.State) -> Bool {
        lhs.isLoading == rhs.isLoading &&
        lhs.pokemon == rhs.pokemon &&
        lhs.pokemonImage == rhs.pokemonImage &&
        lhs.pokemonDetail == rhs.pokemonDetail
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(isLoading)
        hasher.combine(pokemon)
        hasher.combine(pokemonImage)
        hasher.combine(pokemonDetail)
    }
}

struct PokemonDetail: Reducer {
    
    struct Environment {
        public var pokemonService: PokemonHunterKit.PokemonService = .init()
    }
    
    class State {
        let pokemon: Pokemon
        let pokemonImage: UIImage?
        
        init(pokemon: Pokemon, pokemonImage: UIImage?) {
            self.pokemon = pokemon
            self.pokemonImage = pokemonImage
        }
        
        @Published
        var isLoading: Bool = false
        
        @Published
        var pokemonDetail: PokemonHunterKit.PokemonDetail? = nil
    }
    
    enum Action {
        case loadPokemonDetail(Pokemon)
        case pokemonDetailResponse(Result<PokemonHunterKit.PokemonDetail, Error>)
        case isLoading(Bool)
    }
    
    var environment: Environment = .init()
    var body: some ReducerOf<PokemonDetail> {
        Reduce { state, action in
            switch action {
            case .isLoading(let loading):
                state.isLoading = loading
            case .loadPokemonDetail(let pokemon):
                return .run { send in
                    await send(.isLoading(true))
                    await send(.pokemonDetailResponse(
                        await environment.pokemonService.pokemonDetail(pokemon)
                    )
                    )
                    await send(.isLoading(false))
                }
            case .pokemonDetailResponse(.success(let pokemonDetail)):
                state.pokemonDetail = pokemonDetail
            case .pokemonDetailResponse(.failure(let error)):
                print(error.localizedDescription)
            }
            return .none
        }
    }
}
