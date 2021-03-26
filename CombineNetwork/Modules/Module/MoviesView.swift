//
//  MoviesView.swift
//  CombineNetwork
//
//  Created by Andres Felipe Ocampo Eljaiek on 26/03/2021.
//

import SwiftUI

struct MoviesView: View {
    
    @ObservedObject var viewModel = MoviesVM()
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                CardPostCarrouselView(movies: self.viewModel.arrayMovies)
                    .navigationTitle("Movies - iTunes")
                    .onAppear(perform: {
                        self.viewModel.fetchArrayData(count: 99)
                    })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
