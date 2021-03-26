//
//  MoviesVM.swift
//  CombineNetwork
//
//  Created by Andres Felipe Ocampo Eljaiek on 26/03/2021.
//

import Foundation

class MoviesVM: ObservableObject {
        
    @Published var arrayMovies: [ResultITunes] = []
    
    let moviesLC: MoviesLogicControllerProtocol = MoviesLogicController()
    
    func fetchArrayData(count: Int) {
        self.moviesLC.getMoviesFromiTunesApi(count: count) { (resultMoviesEntity) in
            DispatchQueue.main.async {
                self.arrayMovies = resultMoviesEntity.feed?.results ?? []
            }
        } failure: { (networkingError) in
            print(networkingError.localizedDescription)
        }
    }
}
