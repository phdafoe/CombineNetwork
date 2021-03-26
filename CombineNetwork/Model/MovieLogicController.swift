//
//  MovieLogicController.swift
//  CombineNetwork
//
//  Created by Andres Felipe Ocampo Eljaiek on 26/03/2021.
//

import Foundation
import Combine

protocol MoviesLogicControllerProtocol: class {
    func getMoviesFromiTunesApi(count: Int, success: @escaping (MoviesEntity) -> (), failure: @escaping (NetworkingError) -> ())
}

final class MoviesLogicController: MoviesLogicControllerProtocol {
    
    let networkController: NetworkControllerProtocol = NetworkController()
    var subscriptions = Set<AnyCancellable>()
    
    internal func getMoviesFromiTunesApi(count: Int, success: @escaping (MoviesEntity) -> (), failure: @escaping (NetworkingError) -> ()){
        let endpoint = Endpoint.movies(count: count)
        networkController.getMoviesFromiTunes(url: endpoint.url,
                                              entityClass: MoviesEntity.self,
                                              headers: nil).sink { (resultCombine) in
                                                switch resultCombine{
                                                case let .failure(error):
                                                   failure(error)
                                                case .finished: break
                                                }
                                              } receiveValue: { (resultMovieEntity) in
                                                success(resultMovieEntity)
                                              }.store(in: &subscriptions)

    }
}
