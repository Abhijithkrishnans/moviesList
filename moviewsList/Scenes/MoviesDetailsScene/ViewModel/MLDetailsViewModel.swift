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
    init(_ moviesList:[moviesDetailsType]?)
}

class MLDetailsViewModel:MLMovieDetailsProtocol {
    @Published var movieslist: [moviesDetailsType]?
    typealias moviesDetailsType = MLMoviesListModel
    ///Initializers
    
    ///Initializers
    required init(_ moviesList:[moviesDetailsType]?) {
        configureOutput(moviesList)
    }
    
    private func configureOutput(_ moviesList:[moviesDetailsType]?) {
        self.movieslist = moviesList?.compactMap{ mov -> MLMoviesListModel in
            var movobj = mov
            movobj.isDetails = true
            return movobj
        }
    }
}
