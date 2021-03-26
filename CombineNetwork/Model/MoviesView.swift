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
        NavigationView{
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
