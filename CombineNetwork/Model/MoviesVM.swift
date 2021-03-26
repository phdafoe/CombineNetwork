//
//  MoviesVM.swift
//  CombineNetwork
//
//  Created by Andres Felipe Ocampo Eljaiek on 26/03/2021.
//

import Foundation
import Combine

class MoviesVM: ObservableObject {
    
    var didChange = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    let moviesLC = MoviesLogicController()
    
    @Published var arrayMovies: [ResultITunes] = [] {
        willSet {
            moviesLC.getMoviesFromiTunesApi(count: 10) { (result) in
                self.$arrayMovies
                    .map { _ in
                        self.arrayMovies = result.feed?.results ?? []
                    }
                    .eraseToAnyPublisher()
                    .subscribe(self.didChange)
                    .store(in: &self.cancellables)
            } failure: { (networkingError) in
                print(networkingError.localizedDescription)
            }
        }
    }
}
