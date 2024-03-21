//
//  PokemonService.swift
//  PokemonHunter
//
//  Created by saminos on 20/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import PokemonAPI
import ComposableArchitecture
import Foundation


public struct Pokemon: Codable, Hashable {
    public let id: Int
    public let name: String
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public struct CatchPokemon: Codable {
    public let `catch`: Bool
    public var pokemon: Pokemon?
}

public struct RenamePokemon: Codable {
    public let nickname: String
    public let message: String
}

//public class PokemonDetail: PKMPokemon { }
//public class PokemonDetail: PKMPokemon { }

public typealias PokemonDetail = PKMPokemon

extension PokemonDetail: Hashable {
    public static func == (lhs: PokemonDetail, rhs: PokemonDetail) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public class PokemonService {
    public var pokemonAPI: PokemonAPI = .init()
    public var additionalService: AdditionalPokemonService = .init()
    
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
    
    public func pokemonDetail(_ pokemon: Pokemon) async -> Result<PokemonDetail, Error> {
        await withCheckedContinuation { continuation in
            pokemonAPI.pokemonService.fetchPokemon(pokemon.id) { result in
                continuation.resume(with: .success(result.map  {
                    $0 
                }))
            }
        }
    }
    
    public func catchPokemon(_ pokemon: Pokemon) async -> Result<CatchPokemon, Error> {
        await additionalService.fetch(.catch)
    }
    
    public func renamePokemon(_ pokemon: Pokemon?, nickname: String?) async -> Result<RenamePokemon, Error> {
        guard let pokemon else { return .failure(URLError(.badURL))}
        return await additionalService.fetch(.rename(pokemon: pokemon, nickname: nickname))
    }
    
}

