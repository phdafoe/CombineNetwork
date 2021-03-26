//
//  NetworkCoordinator.swift
//  CombineNetwork
//
//  Created by Andres Felipe Ocampo Eljaiek on 26/03/2021.
//

import Foundation
import Combine

protocol NetworkControllerProtocol: class {
    
    typealias Headers = [String: Any]
    func getMoviesFromiTunes<T>(url: URL,
                                entityClass: T.Type,
                                headers: Headers?) -> AnyPublisher<T, NetworkingError> where T : Decodable
}

final class NetworkController: NetworkControllerProtocol {
    
    internal func getMoviesFromiTunes<T>(url: URL,
                                        entityClass: T.Type,
                                        headers: Headers?) -> AnyPublisher<T, NetworkingError> where T : Decodable {
        
        var urlRequest = URLRequest(url: url)
        
        headers?.forEach { (key, value) in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .jsonDecodingPublisher(type: T.self)
    }
    

}
