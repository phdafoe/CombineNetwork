//
//  CardPostCarrouselView.swift
//  CombineNetwork
//
//  Created by Andres Felipe Ocampo Eljaiek on 26/03/2021.
//

import SwiftUI
import struct Kingfisher.KFImage

struct CardPostCarrouselView: View {
    
    let movies: [ResultITunes]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                    ForEach(self.movies) { movie in
                        CardView(movie: movie)
                    }
                }
            })
        })
    }
}

struct CardView: View {

    let movie : ResultITunes

    var body: some View {
        KFImage(URL(string: movie.artworkUrl100 ?? "")!)
            .cornerRadius(10)
            .shadow(radius: 10)
    }
}


