//
//  PokemonService.swift
//  PokemonHunter
//
//  Created by saminos on 20/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import PokemonAPI
import ComposableArchitecture

public class PokemonService {
    public var pokemonAPI: PokemonAPI = .init()
    
    private var pokemonListPage: PKMPagedObject<PKMPokemon>?
    private let initialPaginationState: PaginationState<PKMPokemon> = .initial(pageLimit: 20)
    
    public init(pokemonAPI: PokemonAPI = .init()) {
        self.pokemonAPI = pokemonAPI
    }
    
    var paginationState: PaginationState<PKMPokemon> {
        pokemonListPage == nil ? initialPaginationState : .continuing(pokemonListPage!, .first)
    }
    
//    public func fetchPokemonList() -> Effect<[String], Error> {
//        do {
//            return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Effect<[String], Error>, Error>) in
//                pokemonAPI.pokemonService.fetchPokemonList(paginationState: paginationState) { [weak self] result in
//                    switch result {
//                    case .success(let obj):
//                        self?.pokemonListPage = obj
//                        let pokemonListNames: [String] = obj.results?.compactMap { ($0 as? PKMNamedAPIResource)?.name } ?? []
//    //                    continuation.resume(with: .success(pokemonListNames))
//                        continuation.resume(with: .success(.init(value: pokemonListNames)))
//                    case .failure(let error):
//                        continuation.resume(with: .failure(error))
//                    }
//                }
//            }
//        } catch let error {
//            return .init(error: error)
//        }
//
//
//    }
    
    public func fetchPokemonList() -> Effect<[String], Error> {
        .future { [weak self] callback in
            guard let self = self else { return }
            self.pokemonAPI.pokemonService.fetchPokemonList(paginationState: self.paginationState) { [weak self] result in
                switch result {
                case .success(let obj):
                    self?.pokemonListPage = obj
                    let pokemonListNames: [String] = obj.results?.compactMap { ($0 as? PKMNamedAPIResource)?.name } ?? []
    //                    continuation.resume(with: .success(pokemonListNames))
                    callback(.success(pokemonListNames))
                case .failure(let error):
                    callback(.failure(error))
                }
            }
        }
    }
}
