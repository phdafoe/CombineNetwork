//
//  NetworkCoordinator+Helpers.swift
//  CombineNetwork
//
//  Created by Andres Felipe Ocampo Eljaiek on 26/03/2021.
//

import Foundation
import Combine

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem]? = []
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rss.itunes.apple.com"
        components.path = "/api/v1/es/" + path
        components.queryItems = queryItems
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
    
    var headers: [String: Any] {
        return [
            "Content-Type": "application/json"
        ]
    }
}

extension Endpoint {
    
    static func movies(count: Int) -> Self {
        return Endpoint(path: "/movies/top-movies/all/\(count)/non-explicit.json")
    }
    
    static func books(count: Int) -> Self {
        return Endpoint(path: "/otherEndpointWithParameters",
                        queryItems: [
                            URLQueryItem(name: "limit",
                                         value: "\(count)")
                        ]
        )
    }
    
    static func user(id: String) -> Self {
        return Endpoint(path: "/user/\(id)")
    }
    
}

enum NetworkingError: Error {
    case decoding(DecodingError)
    case incorrectStatusCode(Int)
    case network(URLError)
    case nonHTTPResponse
    case unknown(Error)
}

extension Publisher {
    func mapErrorToNetworkingError() -> AnyPublisher<Output, NetworkingError> {
        mapError { error -> NetworkingError in
            switch error {
            case let decodingError as DecodingError:
                return .decoding(decodingError)
            case let networkingError as NetworkingError:
                return networkingError
            case let urlError as URLError:
                return .network(urlError)
            default:
                return .unknown(error)
            }
        }
        .eraseToAnyPublisher()
    }
}

extension URLSession.DataTaskPublisher {
    func emptyBodyResponsePublisher() -> AnyPublisher<Void, NetworkingError> {
        httpResponseValidator()
        .map { _ in Void() }
        .eraseToAnyPublisher()
    }
}

extension URLSession.DataTaskPublisher {
    func httpResponseValidator() -> AnyPublisher<Output, NetworkingError> {
        tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else { throw NetworkingError.nonHTTPResponse }
            let statusCode = httpResponse.statusCode
            guard (200..<300).contains(statusCode) else { throw NetworkingError.incorrectStatusCode(statusCode) }
            return (data, httpResponse)
        }
        .mapErrorToNetworkingError()
    }

    func httpResponseValidatorDataPublisher() -> AnyPublisher<Data, NetworkingError> {
        httpResponseValidator()
        .map(\.data)
        .eraseToAnyPublisher()
    }

    func jsonDecodingPublisher<T>(type: T.Type) -> AnyPublisher<T, NetworkingError> where T : Decodable {
        httpResponseValidatorDataPublisher()
            .decode(type: T.self, decoder: JSONDecoder())
            .mapErrorToNetworkingError()
    }
}
