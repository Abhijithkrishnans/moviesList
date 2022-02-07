//
//  MLDetailsViewModel.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 06/02/22.
//

import Foundation
import Combine
//MARK: View Model interfaces
protocol MLMovieDetailsProtocol {
    //** Master Data Sources interfaces
    associatedtype moviesDetailsType
    var movieslist: [moviesDetailsType]?{get set}
}

class MLDetailsViewModel:MLMovieDetailsProtocol {
    @Published var movieslist: [moviesDetailsType]?
    typealias moviesDetailsType = MLMoviesListModel
    ///Initializers
    
    ///Initializers
    init(_ moviesList:[moviesDetailsType]?) {
        movieslist = moviesList
        configureOutput()
    }
    
    private func configureOutput() {
        self.movieslist = self.movieslist?.compactMap{ mov -> MLMoviesListModel in
            var movobj = mov
            movobj.isDetails = true
            return movobj
        }
    }
}
