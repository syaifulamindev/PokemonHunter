//
//  AdditionalPokemonService.swift
//  PokemonHunterKit
//
//  Created by saminos on 21/03/24.
//  Copyright © 2024 amin.id. All rights reserved.
//

import Foundation
import Alamofire

public enum APIError: Error {
    case afError(AFError)
}

public class AdditionalPokemonService {
    public var session: URLSession
    public var baseURL: String = "http://localhost:3000/api"
    
    typealias Method = HTTPMethod
    
    enum API {
        case `catch`
        case release(pokemon: Pokemon)
        case rename(pokemon: Pokemon, nickname: String? = nil)
        
        var path: String {
            switch self {
            case .catch:
                return "/catch"
            case .release:
                return "/release"
            case .rename:
                return "/rename"
            }
        }
        
        var method: Method {
            switch self {
            case .catch:
                return .get
            case .release:
                return .delete
            case .rename:
                return .put
            }
        }
    
        var params: [String: String] {
            switch self {
            case .catch:
                return [:]
            case .release(let pokemon):
                return ["pokemonId": "\(pokemon.id)"]
            case .rename(let pokemon, let nickname):
                if let nickname {
                    return ["pokemonId": "\(pokemon.id)", "nickname": nickname]
                } else {
                    return ["pokemonId": "\(pokemon.id)"]
                }
            }
        }
        
    }
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    
    func urlString(from api: API) -> String {
        "\(baseURL)\(api.path)"
    }
    
    func fetch<C: Decodable>(_ api: API) async -> Result<C, Error> {
        await withCheckedContinuation { continuation in
            let urlString = self.urlString(from: api)
            let request = AF.request(
                    urlString,
                    method: api.method,
                    parameters: api.params,
                    encoding: URLEncoding(destination: .queryString),
                    headers: ["Content-Type": "application/json"]
                )
            
            request.responseDecodable { (data: DataResponse<C, AFError>) in
                    
                    let result = data.result.mapError { error in
                        APIError.afError(error) as Error
                    }
                    
                    continuation.resume(with: .success(result))
                }
        }
    }
    
}
