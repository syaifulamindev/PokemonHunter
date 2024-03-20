//
//  PokemonService.swift
//  PokemonHunter
//
//  Created by saminos on 20/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import PokemonAPI
import ComposableArchitecture


public struct Pokemon: Hashable {
    let id: Int
    let name: String
}

public class PokemonService {
    public var pokemonAPI: PokemonAPI = .init()
    
    private var pokemonListPage: PKMPagedObject<PKMPokemon>?
    private let initialPaginationState: PaginationState<PKMPokemon> = .initial(pageLimit: 20)
    
    public init(pokemonAPI: PokemonAPI = .init()) {
        self.pokemonAPI = pokemonAPI
    }
    
    var paginationState: PaginationState<PKMPokemon> {
        guard let pokemonListPage else {
            return initialPaginationState
        }
        return .continuing(pokemonListPage, .next)
    }
    
    public func fetchPokemonList() async -> Result<[Pokemon], Error> {
        
        await withCheckedContinuation { continuation in
            pokemonAPI.pokemonService.fetchPokemonList(paginationState: paginationState) { [weak self] result in
                self?.pokemonListPage = try? result.get()
                
                let mappedResult = result.map {
                    guard let namedAPIResources = ($0.results as?[PKMNamedAPIResource<PKMPokemon>]) else {
                        return [Pokemon]()
                    }
                    return namedAPIResources.compactMap {
                        guard
                            let idString = $0.url?.split(separator: "/").last,
                            let idInt = Int(idString),
                            let name = $0.name
                        else { return nil }
                        return Pokemon(id: idInt, name: name)
                    }
                }
                continuation.resume(with: .success(mappedResult))
            }

        }

    }
    
}
